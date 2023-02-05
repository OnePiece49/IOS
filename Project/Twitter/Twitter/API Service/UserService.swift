//
//  UserService.swift
//  Twitter
//
//  Created by Long Bảo on 08/01/2023.
//

import Foundation
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    func fetchUser(uid: String ,completion: @escaping(User) -> Void) {
        db.collection("users").document(uid).getDocument { docSnap, err in
            if let err = err {
                print("DEBUG: \(err)")
            } else {
                guard let inforUser =  docSnap?.data() else {return}
                let user = User(uid: uid, dictionary: inforUser)
                completion(user)
            }
        }
        
    }
}
