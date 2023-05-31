//
//  BottomCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import UIKit

class BottomFollowerCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomFollowerCollectionViewCell"
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
        return button
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false

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
        addSubview(removeButton)
        
        self.centerYUsernameConstraint = self.usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -9)
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 14),
            
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            usernameLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 110),
            centerYUsernameConstraint,
            
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 15),
            fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 3),
            fullnameLabel.rightAnchor.constraint(equalTo: removeButton.leftAnchor, constant: -15),
            
            followButton.centerYAnchor.constraint(equalTo: usernameLabel.centerYAnchor),
            followButton.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 13),
            
            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
        ])
        avatarImageView.setDimensions(width: 56, height: 56)
        removeButton.setDimensions(width: 80, height: 35)
        removeButton.layer.cornerRadius = 13
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

