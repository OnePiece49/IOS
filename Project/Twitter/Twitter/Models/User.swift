//
//  User.swift
//  Twitter
//
//  Created by Long Bảo on 08/01/2023.
//

import Foundation
import FirebaseAuth

struct User {
    var fullName : String
    var email: String
    var userName : String
    var profileImageURL : String
    var uid: String
    var isFollowed = false
    var stats: UserRealationStats?
    var bio: String?
    
    var isCurrentUser: Bool {return Auth.auth().currentUser?.uid == uid}
    
    init(uid: String, dictionary: [String: Any]) {
        self.uid = uid
        
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.email = dictionary["email"]  as? String ?? ""
        self.userName = dictionary["userName"]  as? String ?? ""
        self.profileImageURL = dictionary["profileImageURL"]  as? String ?? ""
        if let bio = dictionary["bio"] as? String {
            self.bio = bio
        }
    }
}

struct UserRealationStats {
    var followers: Int
    var following: Int
}
