//
//  UserLikedCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit
 
class UserLikedCellViewModel {
    var user: User
    
    var avatarImageUrl: URL? {
        return URL(string: self.user.profileImage ?? "")
    }
    
    var username: String {
        return user.username
    }
    
    var fullname: String {
        return user.fullname
    }
    
    var isFollowed: Bool {
        return user.isFollowed
    }
    
    func followUser() {
        UserService.shared.followUser(uid: user.uid) {
            self.user.isFollowed = true
            self.completion?()
        }
    }
    
    func unfollowUser() {
        UserService.shared.unfollowUser(uid: user.uid) {
            self.user.isFollowed = false
            self.completion?()
        }
    }
    
    var completion: (() -> Void)?
    
    init(user: User) {
        self.user = user
    }
    
}
