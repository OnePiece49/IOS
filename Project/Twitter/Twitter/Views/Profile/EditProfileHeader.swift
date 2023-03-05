//
//  EditProfileHeader.swift
//  Twitter
//
//  Created by Long Bảo on 03/03/2023.
//

import Foundation
import UIKit
import SDWebImage

protocol EditProfileHeaderDelegate: AnyObject {
    func didTapChangePhotoButton()
}

class EditProfileHeader: UIView {
    //MARK: - Properties
    private let user: User
    weak var delegate: EditProfileHeaderDelegate?
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .lightGray
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 3.0
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let changePhotoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Change Profile Photo", for: .normal)
        button.addTarget(self, action: #selector(handleChangePhotoButton), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View LifeCycle
    init(user: User) {
        self.user = user
        super.init(frame: .zero)
        print("DEBUG: EditProfileHeader Init")
        configureUI()
    }
    
    deinit {
        print("DEBUG: EditProfileHeader Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .twitterBlue
        
        addSubview(profileImageView)
        addSubview(changePhotoButton)
        profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -16).isActive = true
        profileImageView.setDimensions(width: 100, height: 100)
        profileImageView.layer.cornerRadius = 100 / 2
        profileImageView.clipsToBounds = true
        changePhotoButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        changePhotoButton.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        
        profileImageView.sd_setImage(with: URL(string: user.profileImageURL), completed: .none)
    }
    
    //MARK: - Selectors
    @objc func handleChangePhotoButton() {
        delegate?.didTapChangePhotoButton()
    }
    
}
