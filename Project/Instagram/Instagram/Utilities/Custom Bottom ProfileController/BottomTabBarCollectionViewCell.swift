//
//  BottomCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 11/05/2023.
//

import UIKit

class BottomTabBarCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomTabBarCollectionViewCell"
    
    lazy var optionImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFit
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
        addSubview(optionImage)
        backgroundColor = .white
        NSLayoutConstraint.activate([
            optionImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            optionImage.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
        optionImage.setDimensions(width: 24, height: 24)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate



