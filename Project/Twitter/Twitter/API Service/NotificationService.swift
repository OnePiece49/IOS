//
//  NotificationService.swift
//  Twitter
//
//  Created by Long Bảo on 25/02/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct NotificationService {
    static let shared = NotificationService()
    private var db = Firestore.firestore()
    
    func uploadNotification(tweet: Tweet? = nil, user: User? = nil, type: NotificationType) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        var values: [String: Any] = ["timestamp": Int(NSDate().timeIntervalSince1970),
                                    "uid": uid, "type": type.rawValue]
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            db.collection("notifications").document(tweet.user.uid).collection("relatedTweet").document().setData(values, merge: true)
        } else if let user = user {
            db.collection("notifications").document(user.uid).collection("follow").document().setData(values, merge: true)
        }
    
        
    }
    
    func fetchNotification(completion: @escaping([Notification]) -> Void) {
        var notifications = [Notification]()
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let groupQueue = DispatchGroup()
        
        db.collection("notifications").document(uid).collection("relatedTweet").getDocuments { querySnap, error in
            guard let documents = querySnap?.documents else {return}
            for document in documents {
                let dicionary = document.data() as [String: AnyObject]
                guard let uid = dicionary["uid"] as? String else {return}
                
                groupQueue.enter()
                UserService.shared.fetchUser(uid: uid) { user in
                    let notification = Notification(user: user, dictionary: dicionary)
                    notifications.append(notification)
                    groupQueue.leave()
                }
            }
            
            db.collection("notifications").document(uid).collection("follow").getDocuments { querySnap, error in
                guard let documents = querySnap?.documents else {return}
                for document in documents {
                    let dicionary = document.data() as [String: AnyObject]
                    guard let uid = dicionary["uid"] as? String else {return}
                    
                    groupQueue.enter()
                    UserService.shared.fetchUser(uid: uid) { user in
                        let notification = Notification(user: user, dictionary: dicionary)
                        notifications.append(notification)
                        groupQueue.leave()
                    }
                }
                
                groupQueue.notify(queue: .main) {
                    completion(notifications)
                }
            }
        }
    }
}
