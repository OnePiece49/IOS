//
//  FollowingViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 01/06/2023.
//

import UIKit

class FollowingViewModel {
    var currentUser: User
    var user: User
    var followingUsers: [User] = []
    private var tempUsers: [User] = []
    
    var completionFecthData: (() -> Void)?
    var duringReloadData: (() -> Void)?
    var completionUpdateFollowUser: (() -> Void)?
    
    func userAtIndexPath(indexPath: IndexPath) -> User {
        return followingUsers[indexPath.row]
    }
    
    var numberUsers: Int {
        return followingUsers.count
    }
    
    func searchUser(name: String) {
        var expectedUsers: [User] = []
        self.tempUsers = followingUsers

        for user in tempUsers {
            if user.fullname.lowercased().contains(name.lowercased()) || user.username.lowercased().contains(name.lowercased()) {
                expectedUsers.append(user)
            }
        }
        
        self.followingUsers = expectedUsers
        self.completionFecthData?()
    }
    
    func fetchData() {
        self.followingUsers = []
        UserService.shared.fetchFollowingUsers(uid: user.uid) { users in
            self.followingUsers = users
            self.completionFecthData?()
        }
    }
    
    func followUser(user: User) {
        for i in 0..<followingUsers.count {
            if followingUsers[i].uid == user.uid {
                UserService.shared.followUser(uid: user.uid) {
                    self.followingUsers[i].isFollowed = true
                    self.user.stats.followings += 1
                    self.completionUpdateFollowUser?()
                }
                return
            }
        }
    }
    
    func unfollowUser(user: User) {
        for i in 0..<followingUsers.count {
            if followingUsers[i].uid == user.uid {
                UserService.shared.unfollowUser(uid: user.uid) {
                    self.followingUsers[i].isFollowed = false
                    self.user.stats.followings -= 1
                    self.completionUpdateFollowUser?()

                }
                return
            }
        }
    }
    
    init(user: User, currentUser: User) {
        self.user = user
        self.currentUser = currentUser
    }
    
    
}
