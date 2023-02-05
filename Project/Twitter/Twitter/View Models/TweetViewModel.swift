//
//  TweetViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 19/01/2023.
//

import Foundation
import UIKit

struct TweetViewModel {
    let tweet: Tweet
    let user: User
    
    var profileImage: URL? {
        guard let imageURL = URL(string: user.profileImageURL) else {return nil}
        return imageURL
    }
    
    var timeStamp: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: tweet.timestamp!, to: now) ?? "1m"
    }
    
    var userTextInfor: NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName, attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])
        title.append(NSAttributedString(string: " @\(user.userName)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray,  NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)]))
        title.append(NSAttributedString(string: " • \(timeStamp)", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
        return title
    }
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
}
