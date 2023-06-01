//
//  FollowerCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 01/06/2023.
//

import UIKit
import FirebaseAuth

class FollowCellViewModel {
    let user: User
    let type: HeaderFollowViewType
    
    var avatarUrl: URL? {
        let url = URL(string: user.profileImage ?? "")
        return url
    }
    
    var username: String? {
        if type == .follower {
            if hasFollowed {
                return user.username
            }
            return "\(user.username)  •  "
        }
        
        return user.username
    }
    
    var isCurrentUser: Bool {
        return Auth.auth().currentUser?.uid == user.uid
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var hasFollowed: Bool {
        return user.isFollowed
    }
    
    init(user: User, type: HeaderFollowViewType) {
        self.user = user
        self.type = type
    }
    
    
}
