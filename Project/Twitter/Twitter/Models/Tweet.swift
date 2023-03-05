//
//  Tweet.swift
//  Twitter
//
//  Created by Long Bảo on 09/01/2023.
//

import Foundation

struct Tweet {
    let caption: String
    var user: User
    let tweetID: String
    let uid: String
    var likes: Int
    var timestamp: Date!
    let retweets: Int
    var didLike = false
    var replyingTo: String?
    var isReply: Bool {return replyingTo != nil}
    
    init(user: User ,tweedID: String, dictionary: [String: Any]) {
        self.user = user
        self.tweetID = tweedID
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweets = dictionary["retweets"] as? Int ?? 0
        
        if let replyingTo = dictionary["replyingTo"] as? String {
            self.replyingTo = replyingTo
        }
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        

        
    }
}
