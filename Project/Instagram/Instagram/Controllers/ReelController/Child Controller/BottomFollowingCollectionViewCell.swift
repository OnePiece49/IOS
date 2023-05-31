//
//  BottomFollowingCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import UIKit

class BottomFollowingCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomFollowingCollectionViewCell"
    var centerYUsernameConstraint: NSLayoutConstraint!
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 56 / 2
        iv.isUserInteractionEnabled = true
//        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInfoUserTapped)))
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "b_lackBink"
        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInfoUserTapped)))
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .systemGray
        label.textAlignment = .left
        label.text = "b_lackBink"
        label.isUserInteractionEnabled = true
//        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleInfoUserTapped)))
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("follow", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitle("Following", for: .normal)
        button.backgroundColor = .systemGray3
        button.setTitleColor(.label, for: .normal)
        return button
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
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(fullnameLabel)
        addSubview(followButton)
        
        self.centerYUsernameConstraint = self.usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -12)
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 18),
            
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            usernameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 120),
            centerYUsernameConstraint,
            
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 6),
            
            followButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
        ])
        avatarImageView.setDimensions(width: 56, height: 56)
        followButton.setDimensions(width: 105, height: 33)
        followButton.layer.cornerRadius = 15
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

