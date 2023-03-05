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
    
    init(tweet: Tweet) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    var profileImage: URL? {
        guard let imageURL = URL(string: user.profileImageURL) else {return nil}
        return imageURL
    }
    
    var userNameText: String {
        return "@\(user.userName)"
    }
    
    var headerTimestamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: tweet.timestamp)
    }
    
    var shouldHideReplyLabel: Bool {
        return !tweet.isReply
    }
    
    var replyText: String {
        guard let replyText = tweet.replyingTo else {return ""}
        return "→ replying to @\(replyText)"
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
    
    var retweetsAttributedString: NSAttributedString? {
        return attributeText(with: tweet.retweets, text: "Retweets")
    }
    
    var likesAttributedString: NSAttributedString? {
        return attributeText(with: tweet.likes, text: "Likes")
    }
    
    var likeButtonTintColor: UIColor {
        return self.tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let imageName = self.tweet.didLike ? "like_filled" : "like"
        return UIImage(named: imageName)!
    }
    
    fileprivate func attributeText(with value: Int, text: String) -> NSAttributedString {
        let title = NSMutableAttributedString(string: "\(value) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])

        title.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
        return title
    }
    
    func sizeForCaptionLabel(forWidth witdh: CGFloat) -> CGSize {
        let measureLabel = UILabel()
        measureLabel.font = UIFont.systemFont(ofSize: 14)
        measureLabel.text = tweet.caption
        measureLabel.numberOfLines = 0
        measureLabel.lineBreakMode = .byWordWrapping
        measureLabel.translatesAutoresizingMaskIntoConstraints = false
        measureLabel.widthAnchor.constraint(equalToConstant: witdh).isActive = true
        return measureLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
    }

}
