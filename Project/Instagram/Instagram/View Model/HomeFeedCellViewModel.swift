//
//  HomeFeedCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit
import FirebaseAuth

class HomeFeedCellViewModel {
    var status: InstaStatus
    
    var attributedCaptionLabel:  NSAttributedString {
        let attributes = NSMutableAttributedString(string: status.user.username,
                                                   attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .semibold),
                                                                .foregroundColor: UIColor.label])
        attributes.append(NSAttributedString(string: " \(String(describing: status.caption))",
                                             attributes: [.font: UIFont.systemFont(ofSize: 14, weight: .regular),
                                                          .foregroundColor: UIColor.label]))
        return attributes
    }
    
    var dateString: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        return formatter.string(from: status.timeStamp)
    }
    
    var avatarURL: URL? {
        URL(string: status.user.profileImage ?? "")
    }
    
    var photoURL: URL? {
        URL(string: status.postImage.imageURL)
    }
    
    var ratioImage: CGFloat {
        CGFloat(1.0 /  status.postImage.aspectRatio)
    }
    
    var likedStatus: Bool {
        return status.likedTus
    }
    
    var username: String {
        return status.user.username
    }
    
    var numberLikes: String {
        return "\(status.numberLikes)"
    }
    
    func hasLikedStatus() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        StatusService.shared.hasUserLikedTus(status: self.status,
                                             uid: uid) { hasLiked in
            self.status.likedTus = hasLiked
            self.completion?()
        }
    }
    
    func likeStatus() {
        StatusService.shared.likeStatus(status: status) {
            self.status.likedTus = true
        }
    }
    
    func unlikeStatus() {
        StatusService.shared.unlikeStatus(status: status) {
            self.status.likedTus = false
        }
    }
    
    func fetchNumberUsersLikedStatus() {
        StatusService.shared.fetchNumberUsersLikedStatus(status: status) { number in
            self.status.numberLikes = number
        }
    }
        
    var completion: (() -> Void)?
    
    init(status: InstaStatus) {
        self.status = status
    }
}
