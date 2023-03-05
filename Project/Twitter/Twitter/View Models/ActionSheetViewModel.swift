//
//  ActionSheetViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 24/02/2023.
//

import Foundation

struct ActionSheetViewModel {
    private let user: User
    
    var options: [ActionSheetOptions] {
        var results = [ActionSheetOptions]()
        if user.isCurrentUser {
            results.append(.delete)
        } else {
            let followOption = user.isFollowed ? ActionSheetOptions.unfollow(user) : ActionSheetOptions.follow(user)
            results.append(followOption)
        }
        results.append(.report)
        return results
    }
    
    init(user: User) {
        self.user = user
    }
    

}

enum ActionSheetOptions {
    case follow(User)
    case unfollow(User)
    case report
    case delete
    
    var description: String {
        switch self {
        case .follow(let user):
            return "Follow @\(user.userName)"
        case .unfollow(let user):
            return "Unfollow @\(user.userName)"
        case .report:
            return "report Tweet"
        case .delete:
            return "Delete Tweet"
        }
    }
    
}
