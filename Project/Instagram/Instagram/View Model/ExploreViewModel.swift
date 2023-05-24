//
//  ExploreViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 24/05/2023.
//

import UIKit

class ExploreViewModel {
    private var users: [User] = []
    var foundedUsers: [User] = []
    
    var numberUserFounded: Int {
        return foundedUsers.count
    }
    
    func fetchOtherUsers() {
        UserService.shared.fetchOtherUsers { users in
            self.users = users
        }
    }
    
    func userAtIndexPath(indexPath: IndexPath) -> User {
        return foundedUsers[indexPath.row]
    }
    
    func searchUsers(name: String)  {
        var expectedUsers: [User] = []
        for user in users {
            if user.fullname.lowercased().contains(name.lowercased()) || user.username.lowercased().contains(name.lowercased()) {
                expectedUsers.append(user)
                
            }
        }
        
        self.foundedUsers = expectedUsers
    }
}
