//
//  UserCell.swift
//  Twitter
//
//  Created by Long Bảo on 05/02/2023.
//

import Foundation
import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            updateCell()
        }
    }
    
    lazy var profileImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .twitterBlue
        image.setDimensions(width: 32, height: 32)
        image.clipsToBounds = true
        image.layer.cornerRadius = 32 / 2
        return image
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.text = "UserName"
        return label
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "FullName"
        return label
    }()
    
    lazy var stackInfor: UIStackView = {
       let stack = UIStackView(arrangedSubviews: [userNameLabel, fullNameLabel])
        stack.spacing = 2
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        return stack
    }()
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(profileImageView)
        addSubview(userNameLabel)
        addSubview(fullNameLabel)
        addSubview(stackInfor)
        applyConstraint()
    }
                       
    func updateCell() {
        guard let user = user else {
            return
        }

        self.userNameLabel.text = user.userName
        self.fullNameLabel.text = user.fullName
        guard let urlImage = URL(string: user.profileImageURL) else {return}
        self.profileImageView.sd_setImage(with: urlImage, completed: .none)
    }
    
    func applyConstraint() {
        let profileImageViewConstraint = [
            profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        let stackConstraint = [
            stackInfor.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 8),
            stackInfor.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(profileImageViewConstraint)
        NSLayoutConstraint.activate(stackConstraint)
    }
}
