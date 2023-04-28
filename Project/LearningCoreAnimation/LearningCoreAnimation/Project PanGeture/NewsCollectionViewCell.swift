//
//  NewsCollectionViewCell.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 26/04/2023.
//

import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "NewsCollectionViewCell"
    
    private lazy var cityImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
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
        cityImageView.frame = frame
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
