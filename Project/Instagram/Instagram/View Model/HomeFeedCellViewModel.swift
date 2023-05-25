//
//  HomeFeedCellViewModel.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit

class HomeFeedCellViewModel {
    let status: InstaStatus
    
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
    
    var username: String {
        return status.user.username
    }
        
    init(status: InstaStatus) {
        self.status = status
    }
}
