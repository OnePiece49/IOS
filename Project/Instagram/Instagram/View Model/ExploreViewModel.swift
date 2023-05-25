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
    var statuses: [InstaStatus] = []
    var completion: (() -> Void)?
    
    var numberUserFounded: Int {
        return foundedUsers.count
    }
    
    func fetchOtherUsers() {
        UserService.shared.fetchOtherUsers { users in
            self.users = users
            self.fetchStatuses()
        }
    }
    
    var numberStatuses: Int {
        return statuses.count
    }
    
    func statusAtIndexPath(indexPath: IndexPath) -> InstaStatus {
        return statuses[indexPath.row]
    }
    
    func userAtIndexPath(indexPath: IndexPath) -> User {
        return foundedUsers[indexPath.row]
    }
    
    func imageUrlAtIndexpath(indexPath: IndexPath) -> URL? {
        let url = URL(string: statuses[indexPath.row].postImage.imageURL)
        return url
    }
    
    private func fetchStatuses() {
        for user in users {
            StatusService.shared.fetchStatusUser(uid: user.uid) { userStatues in
                self.statuses.append(contentsOf: userStatues)
                self.completion?()
            }
        }
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
