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

struct TweetService {
    static let shared = TweetService()
    private let db = Firestore.firestore()
    
    func uploadTweet(caption: String, completion: @escaping (Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        print("DEBUG: \(uid)")
        let timestamp = Int(NSDate().timeIntervalSince1970)
        let tweetID = NSUUID().uuidString
        
        let dataUpload = ["caption": caption, "uid": uid, "likes": 0, "timestamp": timestamp, "retweets": 0] as [String: Any]
        
        db.collection("tweets").document(tweetID).setData(dataUpload) { err in
            if let err = err {
                completion(err)
            } else {
                db.collection("tweet-users").document(uid).setData([tweetID: 1], merge: true) { err in
                    completion(err)
                }
            }
            
        }
        
    }
    
    func fetchTweets(uid: String, completion: @escaping ([Tweet]) -> Void) {
        db.collection("tweets").addSnapshotListener{ querySnap, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            }
            var tweets = [Tweet]()
            for document in querySnap!.documents {
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
}
