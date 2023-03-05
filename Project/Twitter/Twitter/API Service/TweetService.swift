//
//  TweetService.swift
//  Twitter
//
//  Created by Long Bảo on 19/01/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import UIKit

class TweetService {
    static var shared = TweetService()
    private var db = Firestore.firestore()
    
    func uploadTweet(caption: String, type: UploadTweetConfiguration ,completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("DEBUG: \(uid)")
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let tweetID = NSUUID().uuidString
        
        var dataUpload = ["caption": caption, "uid": uid, "likes": 0, "timestamp": timestamp, "retweets": 0] as [String: Any]
      
        switch type {
        case .tweet:
            db.collection("tweets").document(tweetID).setData(dataUpload) { err in
                if let err = err {
                    completion(err)
                } else {
                    self.db.collection("tweet-users").document(uid).setData([tweetID: 1], merge: true) { err in
                        completion(err)
                    }
                }
                
            }
        case .reply(let tweet):
            dataUpload["replyingTo"] = tweet.user.userName
            let documentID = UUID().uuidString
             db.collection("tweet-replies").document(tweet.tweetID).collection("replies").document(documentID).setData(dataUpload, merge: true) { error in
                 
                 self.db.collection("user-replies").document(uid).setData([tweet.tweetID: documentID], merge: true)
                 completion(nil)
            }
        }
        

        
    }
    
//    func fetchAllTweets(completion: @escaping ([Tweet]) -> Void) {
//        db.collection("tweets").addSnapshotListener { querySnap, error in
//            if let error = error {
//                print("DEBUG: \(error.localizedDescription)")
//                return
//            }
//            var tweets = [Tweet]()
//            for document in querySnap!.documents {
//                let dictionary = document.data()
//                guard let uid = dictionary["uid"] as? String else {return}
//                let tweetID = document.documentID
//
//                UserService.shared.fetchUser(uid: uid) { user in
//                    let tweet = Tweet(user: user, tweedID: tweetID, dictionary: dictionary)
//                    tweets.append(tweet)
//                    completion(tweets)
//                }
//
//            }
//
//        }
//    }
    
    func fetchRepliesTweetForUid(user: User,completion: @escaping ([Tweet]) -> Void) {
        let groupQueue = DispatchGroup()
        var tweets = [Tweet]()
        
        db.collection("user-replies").document(user.uid).getDocument{ document, error in
            guard let dicionary = document?.data() as? [String: String] else {return}
            for (key, value) in dicionary {
                groupQueue.enter()
                self.db.collection("tweet-replies").document(key).collection("replies").document(value).getDocument { document, error in
                    guard let dictionary = document?.data() else {return}
                    guard let uid = dictionary["uid"] as? String else {return}
                    guard let tweetID = document?.documentID else {return}
                    
                    UserService.shared.fetchUser(uid: uid) { user in
                        let tweet = Tweet(user: user, tweedID: tweetID, dictionary: dictionary)
                        tweets.append(tweet)
                        groupQueue.leave()
                    }
                }
            }
            groupQueue.notify(queue: .main) {
                completion(tweets)
            }
        }

    }
    
    func fetchAllTweets(completion: @escaping ([Tweet]) -> Void) {
        let groupQueue = DispatchGroup()
        var tweets = [Tweet]()
        
        db.collection("tweets").getDocuments { querySnapShot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnapShot?.documents else {return}
            for (_, document) in documents.enumerated() {
                let dictionary = document.data()
                guard let uid = dictionary["uid"] as? String else {return}
                let tweetID = document.documentID
                
                groupQueue.enter()
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweedID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    groupQueue.leave()
                }
            }
            
            groupQueue.notify(queue: .main) {
                completion(tweets)
            }
        }
    }
    
    func fetchFollwingAndSelfTweet(uid: String, completion: @escaping ([Tweet]) -> Void){
        let groupQueue = DispatchGroup()
        var tweets = [Tweet]()
        db.collection("user-followings").document(uid).getDocument { documentSnap, error in
            guard let documents = documentSnap?.data()  else {
                return
            }

            for (key, _) in documents {
                groupQueue.enter()
                self.fetchTweetsForUid(userID: key) { tweets_user in
                    tweets.append(contentsOf: tweets_user)
                    groupQueue.leave()
                }
            }
            groupQueue.enter()
            self.fetchTweetsForUid(userID: uid) { tweets_self in
                tweets.append(contentsOf: tweets_self)
                groupQueue.leave()
            }
            
            groupQueue.notify(queue: .main) {
                completion(tweets)
            }
        }
    }
    
    func fetchTweetsForUid(userID: String, completion: @escaping ([Tweet]) -> Void) {
        let groupQueue = DispatchGroup()
        db.collection("tweets").getDocuments(completion: { querySnap, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            var tweets = [Tweet]()
            for document in querySnap!.documents {
                let dictionary = document.data()
                guard let uid = dictionary["uid"] as? String else {return}
                if uid == userID {
                    let tweetID = document.documentID
                    groupQueue.enter()
                    UserService.shared.fetchUser(uid: uid) { user in
                        let tweet = Tweet(user: user, tweedID: tweetID, dictionary: dictionary)
                        tweets.append(tweet)
                        groupQueue.leave()
                    }
                }
                
            }
            groupQueue.notify(queue: .main) {
                completion(tweets)
            }
        })
    }
    
    func fetchTweet(tweetID: String, completion: @escaping(Tweet) -> Void) {
        db.collection("tweets").document(tweetID).getDocument { documentSnap, error in
            guard let dicionary = documentSnap?.data() else {return}
            guard let uid = dicionary["uid"] as? String else {return}
            self.db.collection("users").document(uid).getDocument { firDocumentSnap, error in
                guard let dicionaryUser = firDocumentSnap?.data() else {return}
                let user = User(uid: uid, dictionary: dicionaryUser)
                let tweet = Tweet(user: user, tweedID: tweetID, dictionary: dicionary)
                completion(tweet)
            }

        }
    }
    
    func fetchRepliesTweet(tweet: Tweet ,completion: @escaping ([Tweet]) -> Void) {
        var tweets = [Tweet]()
        db.collection("tweet-replies").document(tweet.tweetID).collection("replies").getDocuments { querySnapShot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            
            guard let documents = querySnapShot?.documents else {return}
            for document in documents {
                let dictionary = document.data()
                guard let uid = dictionary["uid"] as? String else {return}
                let tweetID = document.documentID
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = Tweet(user: user, tweedID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchLikesForUser(user: User ,completion: @escaping ([Tweet]) -> Void) {
        let groupQueue = DispatchGroup()
        var tweets = [Tweet]()
        db.collection("user-likes").document(user.uid).collection("likes").getDocuments { querySnap, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }

            guard let documents = querySnap?.documents else {return}
            for (_, document) in documents.enumerated() {
                let tweetID = document.documentID
                groupQueue.enter()
                self.fetchTweet(tweetID: tweetID) { tweet in
                    tweets.append(tweet)
                    groupQueue.leave()
                }
            }
            
            groupQueue.notify(queue: .main) {
                completion(tweets)
            }
            
        }
    }
    
    func likeTweet(tweet: Tweet, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
        
        if !tweet.didLike {
            db.collection("tweet-likes").document(tweet.tweetID).collection("uidUserLiked").document(uid).setData([uid: 1], merge: true) { error in
                self.db.collection("tweets").document(tweet.tweetID).updateData(["likes": likes]) { _ in
                    self.db.collection("user-likes").document(uid).collection("likes").document(tweet.tweetID).setData([tweet.tweetID: 1], merge: true) { _ in
                        completion()
                    }
                }
            }
        } else {
            db.collection("tweet-likes").document(tweet.tweetID).collection("uidUserLiked").document(uid).delete { _ in
                self.db.collection("tweets").document(tweet.tweetID).updateData(["likes": likes]) { _ in
                    self.db.collection("user-likes").document(uid).collection("likes").document(tweet.tweetID).delete { _ in
                        completion()
                    }
                }
            }
        }
    }
    
    func checkIfUserLikedTweet(tweet: Tweet, completion: @escaping(Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        db.collection("user-likes").document(uid).collection("likes").getDocuments { querySnap, error in
            guard let documents = querySnap?.documents else {return}
            for document in documents {
                if document.documentID == tweet.tweetID {
                    completion(true)
                    return
                }
            }
            completion(false)
        }
    }
}
