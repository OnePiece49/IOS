//
//  PhotoCollectionViewCell.swift
//  LoadImageFromLibraryPhoto
//
//  Created by Long Bảo on 02/05/2023.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    let photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.tintColor = .black
        return iv
    }()
    
    static let identifier = "PhotoCollectionViewCell"
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(photoImageView)
        NSLayoutConstraint.activate([
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.topAnchor.constraint(equalTo: topAnchor),
            photoImageView.rightAnchor.constraint(equalTo: rightAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
