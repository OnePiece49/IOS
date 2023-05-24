//
//  BottomTableViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 11/05/2023.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomCollectionViewCell"
    
    lazy var photoImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.masksToBounds = true
        return iv
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(photoImage)
        
        NSLayoutConstraint.activate([
            photoImage.topAnchor.constraint(equalTo: topAnchor),
            photoImage.leftAnchor.constraint(equalTo: leftAnchor),
            photoImage.rightAnchor.constraint(equalTo: rightAnchor),
            photoImage.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

