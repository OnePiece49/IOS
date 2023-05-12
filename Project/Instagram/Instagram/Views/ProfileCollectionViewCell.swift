//
//  ProfileCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 05/05/2023.
//

import Foundation

import UIKit

class ProfileCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ProfileCollectionViewCell"
    
    
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
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
