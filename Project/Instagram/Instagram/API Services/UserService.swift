//
//  UserService.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class UserService {
    static let shared = UserService()
    private let db = Firestore.firestore()
    
    func fetchUser(uid: String, completion: @escaping (User? ,Error?) -> Void) {
        let queue = DispatchQueue(label: "fetching user")
        queue.async {
            FirebaseRef.ref_user.document(uid).getDocument { documentSnap, error in
                if let error = error {
                    completion(nil ,error)
                }
                
                guard let dictionary = documentSnap?.data() else {
                    return
                }
                
                let user = User(uid: uid, dictionary: dictionary)
                completion(user, nil)
            }
        }
    }
    
    func fetchOtherUsers(completion: @escaping ([User]) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        var users: [User] = []
        
        FirebaseRef.ref_user.getDocuments { querySnap, _ in
            guard let documents = querySnap?.documents else { return }
            
            for document in documents {
                let dictionary = document.data()
                let uid = document.documentID
                if uid == currentUid {continue}
                let user = User(uid: uid, dictionary: dictionary)
                users.append(user)
            }
            
            completion(users)
            
        }
    }
    
    func updateInfoUser(user: User, image: UIImage?, completion: @escaping () -> Void) {
        guard let image = image else {
            self.updateUser(user: user) {
                completion()
            }
            return
        }

        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        
        let fileID = NSUUID().uuidString
        let ref = Storage.storage().reference().child(fileID)
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion()
            }
            
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {
                    self.updateUser(user: user) {
                        completion()
                    }
                    return
                }
                
                self.updateUser(user: user, imageUrl: profileImageUrl) {
                    completion()
                }
            }
        }
    }
    
    private func updateUser(user: User,  imageUrl: String? = nil, completion: @escaping () -> Void) {
        let dictionary: [String: Any]
        
        if let imageUrl = imageUrl {
            dictionary = ["fullname": user.fullname,
                         "username": user.username,
                         "profileImage": imageUrl,
                         "bio": user.bio ?? "",
                         "link": user.link ?? ""]
        } else {
            dictionary = ["fullname": user.fullname,
                          "username": user.username,
                          "bio": user.bio ?? "",
                          "link": user.link ?? ""]
        }
  
        
        self.db.collection("users").document(user.uid).setData(dictionary, merge: true) { error in
            completion()
        }
    }
    
}
