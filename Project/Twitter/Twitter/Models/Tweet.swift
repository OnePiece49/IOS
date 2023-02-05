//
//  Tweet.swift
//  Twitter
//
//  Created by Long Bảo on 09/01/2023.
//

import Foundation

struct Tweet {
    let caption: String
    let user: User
    let tweetID: String
    let uid: String
    let likes: Int
    var timestamp: Date?        //DDel hiểu sao biến var thì trong hàm init có thể không cần assign value luôn mà biến let thì bắt buộc phải gán
    let retweets: Int
    
    init(user: User ,tweedID: String, dictionary: [String: Any]) {
        self.user = user
        self.tweetID = tweedID
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweets = dictionary["retweets"] as? Int ?? 0
        
        if let timestamp = dictionary["timestamp"] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
        
    }
}
