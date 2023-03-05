//
//  NotificationViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 28/02/2023.
//

import Foundation
import UIKit



struct NotificationViewModel {
    private let notification: Notification
    private let type: NotificationType
    private let user: User
    
    init(notification: Notification) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        return formatter.string(from: notification.timestamp!, to: now) ?? "1m"
    }
    
    var notificationMessage: String {
        switch type {
        case .follow:
            return " Started Following you "
        case .like:
            return " liked one of your tweet"
        case .reply:
            return " reply to your tweet"
        case .retweet:
            return " retwwet yout tweet"
        case .mention:
            return " mention you in a tweet"
        }
    }
    
    var shouldHideFollowButton: Bool {
        return type != .follow
    }
    
    var backgroudColorButton: UIColor {
        return user.isFollowed ? UIColor.white : UIColor.black
    }
    
    var titleFollowButton: String {
        return user.isFollowed ? "Following" : "Follow"
    }
    
    var titleColorFollowButton: UIColor {
        return user.isFollowed ? UIColor.black : UIColor.white
    }
    
    var notificationText: NSAttributedString? {
        guard let timestampString = timestampString else { return nil}
        
        let attributeText = NSMutableAttributedString(string: user.userName, attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 12)])
        
        attributeText.append(NSAttributedString(string: notificationMessage, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)]))
        
        attributeText.append(NSAttributedString(string: " \(timestampString) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray]))
        return attributeText
    }
    
    var progileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
}
