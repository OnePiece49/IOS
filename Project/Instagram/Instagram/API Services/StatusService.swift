//
//  StatusService.swift
//  Instagram
//
//  Created by Long Bảo on 23/05/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class StatusService {
    static let shared = StatusService()
    private let db = Firestore.firestore()
    
    
    func uploadStatus(image: UIImage?,
                      uid: String,
                      status: String?,
                      completion: @escaping(Error?) -> Void) {
        guard let image = image else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else {return}
        
        let aspectRatio = Float(image.size.width) / Float(image.size.height)
        let timestamp = Int(NSDate().timeIntervalSince1970)
        
        let fileID = NSUUID().uuidString
        let ref = Storage.storage().reference().child(fileID)
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion(error)
            }
            
            ref.downloadURL { url, error in
                guard let profileImageUrl = url?.absoluteString else {return}
                
                let dictionary: [String: Any] = [UsersConstant.profileImage: profileImageUrl,
                                                 UsersConstant.timestamp: timestamp,
                                                 UsersConstant.uid: uid,
                                                 UsersConstant.aspectRatio: aspectRatio,
                                                 UsersConstant.caption: status ?? ""]
                
                let statusID = NSUUID().uuidString
                FirebaseRef.ref_uploadStatus.document(statusID).setData(dictionary) { _ in
                    FirebaseRef.ref_userStatus.document(uid).setData([statusID: "1"], merge: true) { _ in
                        completion(error)
                    }
                }
            }
        }
    }
    
    func fetchTusUser(uid: String,
                      completion: @escaping(InstaStatus?) -> Void) {
        FirebaseRef.ref_userStatus.document(uid).getDocument { documentSnap, error in
            guard let documentSnap = documentSnap else { return }
            guard let dictionary = documentSnap.data() as? [String: String] else {return}
            print("DEBUG: begin \(Date.now)")

            let queue = DispatchQueue(label: "fectching Tus")
            for document in dictionary {
                let statusID = document.key
                queue.async {
                    FirebaseRef.ref_uploadStatus.document(statusID).getDocument { documentSnap, _ in
                        guard let documentSnap = documentSnap else { return }
                        guard let dictionary = documentSnap.data()  else {return}
                        guard let uid = dictionary[UsersConstant.uid] as? String else {return}
                        
                        UserService.shared.fetchUser(uid: uid) { user, _ in
                            guard let user = user else {return}
                            
                            let status = InstaStatus(user: user, statusId: statusID, dictionary: dictionary)
                            DispatchQueue.main.async {
                                completion(status)

                            }
                        }
                    }
                }

                
            }
        }
    }
}
