//
//  EditProfileViewModel.swift
//  Twitter
//
//  Created by Long Bảo on 03/03/2023.
//

import Foundation

enum EditProfileOptions: Int, CaseIterable {
    case fullName
    case userName
    case bio
    
    var description: String {
        switch self {
        case .fullName:
            return "Name"
        case .userName:
            return "UserName"
        case .bio:
            return "Bio"
        }
    }
}

struct EditProfileViewModel {
    private let user: User
     let option: EditProfileOptions
    
    init(user: User, option: EditProfileOptions) {
        self.user = user
        self.option = option
    }
    
    var shouldHideInforTextField: Bool {
        return option == .bio
    }
    
    var shouldHideBioTextField: Bool {
        return option != .bio
    }
    
    var titletext: String {
        return option.description
    }
    
    var optionValue: String {
        switch option {
        case .fullName:
            return user.fullName
        case .userName:
            return user.userName
        case .bio:
            return user.bio ?? "Bio"
        }
    }
}
