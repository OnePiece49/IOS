//
//  InstagramConstant.swift
//  Instagram
//
//  Created by Long Bảo on 23/05/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

struct UsersConstant {
    static let user = "users"
    static let username = "username"
    static let fullname = "fullname"
    static let profileImage = "profileImage"
    static let bio = "bio"
    static let link = "link"
    static let numberLikes = "numberLikes"
    static let numberComments = "numberComments"
    static let caption = "caption"
    static let timestamp = "timestamp"
    static let aspectRatio = "aspectRatio"
    static let uid = "uid"

}


struct FirebaseRef {
    static let ref_user = Firestore.firestore().collection("users")
    static let ref_uploadStatus = Firestore.firestore().collection("status")
    static let ref_userStatus = Firestore.firestore().collection("users-status")
    static let ref_followUser = Firestore.firestore().collection("follow-users")                //Check những ai đang follow 1 người
    static let ref_followingUser = Firestore.firestore().collection("following-users")          //Check 1 người đang following những ai
}
