//
//  Users.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit

struct User {
    let email: String
    var username: String
    var fullname: String
    var uid: String
    var profileImage: String?
    var bio: String?
    var link: String?
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        self.email = dictionary["email"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullname = dictionary["fullname"] as? String ?? ""
        self.profileImage = dictionary["profileImage"] as? String ?? ""
        self.bio = dictionary["bio"] as? String ?? ""
        self.link = dictionary["link"] as? String ?? ""
    }
}
