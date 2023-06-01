//
//  BottomCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import UIKit

protocol BottomFollowerCellDelehgate: AnyObject {
    func didSelectFollowButton(cell: BottomFollowerCollectionViewCell, user: User)
    func didSelectRemmoveButton(cell: BottomFollowerCollectionViewCell, user: User)
}

class BottomFollowerCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomFollowerCollectionViewCell"
    weak var delegate: BottomFollowerCellDelehgate?
    
    var centerYUsernameConstraint: NSLayoutConstraint!
    var viewModel: FollowCellViewModel? {
        didSet {updateUI()}
    }
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 56 / 2
        iv.isUserInteractionEnabled = true
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
        return label
    }()
    
    private lazy var followButton: UIButton = {
        let button = UIButton()
        button.setTitle("follow", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font  = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.isHidden = true
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var removeButton: UIButton = {
        let button = UIButton()
        button.setTitle("Remove", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .systemGray5
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleRemoveButtonTapped), for: .touchUpInside)
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
            followButton.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor),
            
            removeButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            removeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
        ])
        avatarImageView.setDimensions(width: 56, height: 56)
        removeButton.setDimensions(width: 80, height: 35)
        removeButton.layer.cornerRadius = 13
    }
    
    func updateUI() {
        guard let viewModel = viewModel else {
            return
        }
        
        self.avatarImageView.sd_setImage(with: viewModel.avatarUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.usernameLabel.text = viewModel.username
        self.fullnameLabel.text = viewModel.fullname
        if viewModel.hasFollowed {
            self.followButton.isHidden = true
        } else {
            self.followButton.isHidden = false
        }
    }
    
    func updateFollowButtonAfterTapped() {
        guard let hasFollowed = viewModel?.hasFollowed else {return}
        if hasFollowed {
            followButton.setTitle("following", for: .normal)
            followButton.setTitleColor(.label, for: .normal)

        } else {
            followButton.setTitle("follow", for: .normal)
            followButton.setTitleColor(.systemBlue, for: .normal)
        }
    }
    
    //MARK: - Selectors
    @objc func handleFollowButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didSelectFollowButton(cell: self, user: viewModel.user)
    }
    
    @objc func handleRemoveButtonTapped() {
        guard let user = viewModel?.user else {return}
        self.delegate?.didSelectRemmoveButton(cell: self, user: user)
    }
}
//MARK: - delegate

