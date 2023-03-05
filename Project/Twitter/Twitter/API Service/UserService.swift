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
    
    
    func fetchUsers(completion: @escaping([User]) -> Void) {
        db.collection("users").getDocuments { docSnap, error in
            var users =  [User]()
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
            } else {
                guard let dictionaries = docSnap?.documents else {return}
                for dictionary in dictionaries {
                    let uid = dictionary.documentID
                    let inforUser = dictionary.data()
                    let user = User(uid: uid, dictionary: inforUser)
                    users.append(user)
                }
            }
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        db.collection("user-followings").document(currentUid).setData([uid: 1], merge: true) { error in
            self.db.collection("user-followers").document(uid).setData([currentUid: 1]) { error in
                completion(error)
            }
        }
    }

    func unfollowUser(uid: String, completion: @escaping (Error?) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        db.collection("user-followings").document(currentUid).updateData([uid: FieldValue.delete()]) { error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion(error)
                return
            }
            
            self.db.collection("user-followers").document(uid).updateData([currentUid: FieldValue.delete()]) { error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(error)
                    return
                }
                completion(nil)
            }
        }
    }
    
    func checkIfUserIsFollowing(uid: String, completion: @escaping (Bool) -> Void) {
        guard let currentUid = Auth.auth().currentUser?.uid else {return}
        
        db.collection("user-followings").document(currentUid).getDocument { data, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                return
            } else {
                guard let data = data?.data() as? [String: Int] else {
                    return
                }
                guard data[uid] != nil else {
                    completion(false)
                    return
                }
                completion(true)
            }
            
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping (UserRealationStats?) -> Void) {
        db.collection("user-followers").document(uid).getDocument { documentFollowersSnapShot, error in
            if let error = error {
                print("DEBUG: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            self.db.collection("user-followings").document(uid).getDocument { documentFollowingsSnapShot, error in
                if let error = error {
                    print("DEBUG: \(error.localizedDescription)")
                    completion(nil)
                    return
                }
                let userRelaion = UserRealationStats(followers: documentFollowersSnapShot?.data()?.count ?? 0, following: documentFollowingsSnapShot?.data()?.count ?? 0)
                completion(userRelaion)
            }
        }
    }
    
    func updateUserInfor(user: User, completion: @escaping() -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
         let values = ["fullName": user.fullName,
                      "userName": user.userName,
                       "bio": user.bio as Any] as [String: Any]
        db.collection("users").document(uid).setData(values, merge: true) { error in
            completion()
        }
    }
    
    func updateProfileImage(image: UIImage, completion: @escaping() -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let fileID = NSUUID().uuidString
        let ref = Storage.storage().reference().child(fileID)
        ref.putData(imageData, metadata: nil) { (meta, error) in
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                let values = ["profileImageURL": profileImageUrl]
                
                self.db.collection("users").document(uid).setData(values, merge: true) { error in
                    completion()
                }
            }
        }
    }
    
}
