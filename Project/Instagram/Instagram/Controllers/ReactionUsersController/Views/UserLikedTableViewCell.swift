//
//  UserLikedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit
import SDWebImage
import FirebaseAuth

protocol UserLikedTableViewDelegate: AnyObject {
    func didTapUserInfor(user: User)
}

class UserLikedTableViewCell: UITableViewCell {
    static let identifier = "UserLikedTableViewCell"
    weak var delegate: UserLikedTableViewDelegate?
    
    var viewModel: UserLikedCellViewModel? {
        didSet {updateUI()}
    }
    
    lazy var editButton = Utilites.createHeaderProfileButton(with: "Follow")
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 54 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(fullnameLabel)
        contentView.addSubview(editButton)
        
        NSLayoutConstraint.activate([
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            usernameLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -7),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            
            fullnameLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 1),
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            fullnameLabel.rightAnchor.constraint(equalTo: editButton.leftAnchor, constant: -20),
            
            editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            editButton.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            
        ])
        avatarImageView.setDimensions(width: 54, height: 54)
        editButton.setDimensions(width: 135, height: 32)
        editButton.layer.cornerRadius = 14
        editButton.backgroundColor = .systemBlue
        editButton.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
    }
    
    func updateUI() {
        guard let viewModel = viewModel, let currentUid = Auth.auth().currentUser?.uid else {
            return
        }
        
        viewModel.completion = { [weak self] in
            self?.updateFollowButton()
        }
        
        self.avatarImageView.sd_setImage(with: viewModel.avatarImageUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.fullnameLabel.text = viewModel.fullname
        self.usernameLabel.text = viewModel.username
        if viewModel.user.uid == currentUid {
            editButton.isHidden = true
            return
        } else {
            editButton.isHidden = false
        }
        
        if viewModel.isFollowed {
            editButton.setTitle("Following", for: .normal)
            editButton.backgroundColor = .systemGray3
            editButton.setTitleColor(.label, for: .normal)
        } else {
            editButton.setTitle("Follow", for: .normal)
            editButton.backgroundColor = . systemBlue
            editButton.setTitleColor(.white, for: .normal)
        }
    }
    
    //MARK: - Selectors
    @objc func handleFollowButtonTapped() {
        guard let isFollowed = viewModel?.isFollowed else {return}
        
        
        if isFollowed {
            viewModel?.unfollowUser()
        } else {
            viewModel?.followUser()
        }
    }
    
    func updateFollowButton() {
        guard let isFollowed = self.viewModel?.isFollowed else {return}
        
        if isFollowed {
            self.editButton.setTitle("Following", for: .normal)
            self.editButton.backgroundColor = .systemGray3
            self.editButton.setTitleColor(.label, for: .normal)
        } else {
            self.editButton.setTitle("Follow", for: .normal)
            self.editButton.backgroundColor = .systemBlue
            self.editButton.setTitleColor(.white, for: .normal)
        }
    }
}
//MARK: - delegate

