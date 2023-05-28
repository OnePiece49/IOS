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
    
    func fetchUser(uid: String, completion: @escaping (User) -> Void) {
        let queue = DispatchQueue(label: "fetching user")
        queue.async {
            FirebaseRef.ref_user.document(uid).getDocument { documentSnap, error in
                if let _ = error {return}

                guard let dictionary = documentSnap?.data() else {return}
                
                let user = User(uid: uid, dictionary: dictionary)
                DispatchQueue.main.async {
                    completion(user)
                }
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
    
    func followUser(uid: String, completion: @escaping () -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        FirebaseRef.ref_followUser.document(uid).setData([currentUid: "1"], merge: true) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            }
            FirebaseRef.ref_followingUser.document(currentUid).setData([uid: "1"], merge: true) {error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
    
    func unfollowUser(uid: String, completion: @escaping () -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        FirebaseRef.ref_followUser.document(uid).updateData([currentUid: FieldValue.delete()]) { _ in
            FirebaseRef.ref_followingUser.document(currentUid).updateData([uid: FieldValue.delete()]) { _ in
                completion()
            }
        }
    }
    
    func fetchFollowingUsers(uid: String, completion: @escaping ([User]) -> Void) {
        var users: [User] = []
        var numberUser = 0
        FirebaseRef.ref_followingUser.document(uid).getDocument { documentSnap, _ in
            guard let documentsData = documentSnap?.data() else {return}
            
            for document in documentsData {
                self.fetchUser(uid: document.key) { user in
                    users.append(user)
                    numberUser += 1
                    
                    if numberUser == documentsData.count {
                        completion(users)
                    }
                }
            }
            

        }
    }
    
    func hasFollowedUser(uid: String, completion: @escaping (Bool) -> ()) {
        guard let currentUid = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }
        
        FirebaseRef.ref_followingUser.document(currentUid).getDocument { documentSnap, _ in
            guard let data = documentSnap?.data() else {
                completion(false)
                return
            }
            
            if let _ = data[uid] {
                completion(true)
                return
            }
            
            completion(false)
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
    
    func fetchUserRelationStats(uid: String, completion: @escaping (UserRelationStats) -> Void) {
        var relationStats = UserRelationStats(followers: 0, followings: 0)
        FirebaseRef.ref_followingUser.document(uid).getDocument { documentSnap, _ in
            guard let documentData = documentSnap?.data() else {
                FirebaseRef.ref_followUser.document(uid).getDocument { documentSnap, _ in
                    guard let documentData = documentSnap?.data() else {
                        completion(relationStats)
                        return
                    }
                    
                    relationStats.followers = documentData.count
                    completion(relationStats)
                }
                return
            }
            
            relationStats.followings = documentData.count
            FirebaseRef.ref_followUser.document(uid).getDocument { documentSnap, _ in
                guard let documentData = documentSnap?.data() else {
                    completion(relationStats)
                    return
                }
                
                relationStats.followers = documentData.count
                completion(relationStats)
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
