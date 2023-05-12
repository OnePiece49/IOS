//
//  StoryCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 06/05/2023.
//

import UIKit

class StoryCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "StoryCollectionViewCell"
    
    private let storyImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 60 / 2
        return iv
    }()
    
    private lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tin nổi bật"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .light)
        label.textAlignment = .center
        return label
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
        addSubview(storyImageView)
        addSubview(storyLabel)
        NSLayoutConstraint.activate([
            storyImageView.topAnchor.constraint(equalTo: topAnchor),
            storyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        storyImageView.setDimensions(width: 60, height: 60)
        
        NSLayoutConstraint.activate([
            storyLabel.centerXAnchor.constraint(equalTo: storyImageView.centerXAnchor),
            storyLabel.topAnchor.constraint(equalTo: storyImageView.bottomAnchor, constant: 6),
        ])
        storyLabel.setDimensions(width: 80, height: 15)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

