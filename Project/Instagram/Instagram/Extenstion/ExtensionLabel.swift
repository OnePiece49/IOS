//
//  ExtensionLabel.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit

extension UILabel {
    var isTruncated: Bool {
        guard let labelText = text else {
            return false
        }

        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font ?? .systemFont(ofSize: 15)],
            context: nil).size

//        print("DEBUG: \(labelTextSize.height) and \(frame.size.height) and \(labelText))")
        return labelTextSize.height > bounds.size.height
    }
}
