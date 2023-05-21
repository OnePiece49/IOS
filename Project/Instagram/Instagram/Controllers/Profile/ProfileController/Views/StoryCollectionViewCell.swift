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
    
    var storyLayer: InstagramStoryLayer!
    var isRunningAnimationStory = false

    private lazy var storyImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 54 / 2
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleImageStoryTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var storyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Tin nổi bật"
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
            storyImageView.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            storyImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            storyLabel.centerXAnchor.constraint(equalTo: storyImageView.centerXAnchor),
            storyLabel.topAnchor.constraint(equalTo: storyImageView.bottomAnchor, constant: 8.3),
        ])
        storyImageView.setDimensions(width: 54, height: 54)
        storyLabel.setDimensions(width: 80, height: 15)
        
        layoutIfNeeded()
        self.storyLayer = InstagramStoryLayer(centerPoint: CGPoint(x: storyImageView.bounds.midX, y: storyImageView.bounds.midY), width: self.storyImageView.bounds.width + 10, lineWidth: 2.35)
        storyImageView.layer.addSublayer(storyLayer)
        storyImageView.layer.masksToBounds = false

    }
    
    //MARK: - Selectors
    @objc func handleImageStoryTapped() {
        if !isRunningAnimationStory {
            self.storyLayer.startAnimation()
        } else {
            self.storyLayer.stopAnimation()
        }
        
        isRunningAnimationStory = !isRunningAnimationStory

    }
    
}
//MARK: - delegate

