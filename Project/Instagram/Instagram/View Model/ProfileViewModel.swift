//
//  ProfileViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import FirebaseAuth

class ProfileViewModel {
    var user: User?
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
            UserService.shared.fetchUserRelationStats(uid: uid) { relationStats in
                self.user?.stats = relationStats
                StatusService.shared.fetchStatusUser(uid: uid) { statuses in
                    self.user?.numberStatus = statuses.count
                    self.completion?()
                }
            }
        }
    }
    
    var completion: (() -> Void)?
    
    var isFollowed: Bool {
        return user?.isFollowed == true
    }
    
    func hasFollowedUser() {
        guard let user = user else {return}

        UserService.shared.ifUserHasFollowed(uid: user.uid) { isFollowed in
            self.user?.isFollowed = isFollowed
            UserService.shared.fetchUserRelationStats(uid: user.uid) { relationStats in
                self.user?.stats = relationStats
                StatusService.shared.fetchStatusUser(uid: user.uid) { statuses in
                    self.user?.numberStatus = statuses.count
                    self.completion?()
                }
            }
        }
    }
    
    func followUser() {
        guard let user = user else {
            return
        }

        UserService.shared.followUser(uid: user.uid) {
            self.user?.isFollowed = true
        }
    }
    
    func unfollowUser() {
        guard let user = user else {
            return
        }

        UserService.shared.unfollowUser(uid: user.uid) {
            self.user?.isFollowed = false
        }
    }
    
    func referchData() {
        self.hasFollowedUser()
    }
}
