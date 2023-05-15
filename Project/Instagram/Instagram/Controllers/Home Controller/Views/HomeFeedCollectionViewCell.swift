//
//  HomeFeedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 14/05/2023.
//


import UIKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ProfileCollectionViewCell"
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "black_pink"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemCyan
        return iv
    }()
    
    private lazy var heardImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setDimensions(width: 40, height: 40)

        return iv
    }()
    
    private lazy var commentImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "message"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setDimensions(width: 40, height: 40)

        return iv
    }()
    
    private lazy var shareImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "shareInsta"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heardImageView,
                                                   commentImageView,
                                                   shareImageView])
        stack.axis = .horizontal
        stack.spacing = 10
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        self.activeConstraint()
    }
    
    func activeConstraint() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(actionStackView)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 4)
        ])
        avatarImageView.setDimensions(width: 40, height: 40)
        
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: avatarImageView.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 6.5),
        ])
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 6),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        photoImageView.setDimensions(width: bounds.width, height: 350)
        
        NSLayoutConstraint.activate([
            actionStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 7),
            actionStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 7),
            actionStackView.heightAnchor.constraint(equalToConstant: 40),
            actionStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            actionStackView.widthAnchor.constraint(equalToConstant: 200),
        ])
        
        
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

