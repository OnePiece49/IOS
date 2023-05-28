//
//  File.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit

class UserLikedViewModel {
    let status: InstaStatus
    var users: [User] = []
    
    var completion: (() -> Void)?
    
    func userAtIndexPath(indexPath: IndexPath) -> User {
        return users[indexPath.row]
    }
    
    var numberUsers: Int {
        return users.count
    }
    
    func fetchData() {
        var numberUser = 0
        StatusService.shared.fetchUsersLikeStatus(status: status) { users in
            users.forEach { user in
                var user = user
                UserService.shared.hasFollowedUser(uid: user.uid) { isFollowed in
                    user.isFollowed = isFollowed
                    self.users.append(user)
                    numberUser += 1
                    if numberUser == users.count {
                        self.completion?()
                    }
                }
            }
        }
    }
    
 
    
    init(status: InstaStatus) {
        self.status = status
    }
}
