//
//  Comment.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import UIKit

struct Comment {
    let content: String
    let statusID: String
    let user: User
    var timestamp: Date!
    
    init(dictionary: [String: Any], user: User) {
        self.content = dictionary[UsersConstant.comment] as? String ?? ""
        self.statusID = dictionary[UsersConstant.statusId] as? String ?? ""
        self.user = user
        
        if let timestamp = dictionary[UsersConstant.timestamp] as? Double {
            self.timestamp = Date(timeIntervalSince1970: timestamp)
        }
    }
}
