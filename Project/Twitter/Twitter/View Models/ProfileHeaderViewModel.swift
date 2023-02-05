//
//  ProfileHeaderViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 20/01/2023.
//

import Foundation
import UIKit

enum ProfileFilterOption: Int {
    case Tweets
    case Replies
    case Likes
    
    var description: String {
        switch self {
        case .Tweets: return "Tweets"
        case .Replies: return "Tweets & Replies"
        case .Likes: return "Likes"
        }
    }
}

struct ProfileHeaderViewModel {
    private let user: User
    
    var followersString: NSAttributedString? {
        return attributeText(with: 0, text: "followers")
    }
    
    var followingString: NSAttributedString? {
        return attributeText(with: 2, text: "following")
    }
    
    var actionButtonTitle: String {
        if user.isCurrentUser {
            return "Edit Profile"
        } else {
            return "Follow"
        }
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
