//
//  InstaStatus.swift
//  Instagram
//
//  Created by Long Bảo on 23/05/2023.
//

import UIKit

struct PostImage {
    let imageURL: String
    let aspectRatio: Float  ///width / height
}

struct InstaStatus {
    let user: User
    let caption: String?
    let postImage: PostImage
    var timeStamp: Date!
    let statusId: String
    var numberLikes: Int
    var numberComments: Int
    
    init(user: User, statusId: String, dictionary: [String: Any]) {
        self.user = user
        self.statusId = statusId
        self.caption = dictionary[UsersConstant.caption] as? String ?? ""
        self.numberLikes = dictionary[UsersConstant.numberComments] as? Int ?? 0
        self.numberComments = dictionary[UsersConstant.numberComments] as? Int ?? 0
        
        if let timestamp = dictionary[UsersConstant.timestamp] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timestamp)
        }
        
        let imageURL = dictionary[UsersConstant.profileImage] as? String ?? ""
        let aspectRatio = dictionary[UsersConstant.aspectRatio] as? Float ?? 0.0
        self.postImage = PostImage(imageURL: imageURL, aspectRatio: aspectRatio)
    }
}
