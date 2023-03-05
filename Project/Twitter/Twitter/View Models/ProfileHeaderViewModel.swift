//
//  ProfileHeaderViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 20/01/2023.
//

import Foundation
import UIKit

enum ProfileFilterOption: Int {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributeText(with: user.stats?.followers ?? 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributeText(with: user.stats?.following ?? 0, text: "following")
    }
    
    var bioString: String {
        return user.bio ?? "This is a user bio will span more than one line for test purpuse"
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        }
        
        if !user.isFollowed && !user.isCurrentUser {
            return "Follow"
        }
        
        if user.isFollowed {
            return "Following"
        }
        
        return "Loading"
    }
    
    init(user: User) {
        self.user = user
    }
    
    fileprivate func attributeText(with value: Int, text: String) -> NSAttributedString {
        let title = NSMutableAttributedString(string: "\(value) ", attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 14)])

        title.append(NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14) ]))
        return title
    }
}
