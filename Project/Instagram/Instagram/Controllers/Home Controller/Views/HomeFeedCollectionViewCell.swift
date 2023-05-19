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
    var actionBar: NavigationCustomView!
    
    private lazy var avatarUserUpTusImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 36 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "black_pink"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemCyan
        return iv
    }()
    
    private let numberLikedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "102 lượt thích"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var statusLabel: UILabel = Utilites.createStatusFeedLabel(username: "black_pink", status: "Happy birthday Blackpink, have a good day, wish you have all lucky :))")
    
    private lazy var getCommentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Xem 1531 bình luận"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private let timePostTusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "27 minutes ago"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        return label
    }()
    
    private lazy var fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "like1"),
                                                  sizeImage: CGSize(width: 27, height: 27))
                                                   
        let attributeSecondLeftButton = AttibutesButton(image: UIImage(named: "comment"),
                                                        sizeImage: CGSize(width: 27, height: 27))
                                                        
        let attributeThreeLeftButton = AttibutesButton(image: UIImage(named: "share"),
                                                  sizeImage: CGSize(width: 32, height: 32))
        
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "Bookmark"),
                                                  sizeImage: CGSize(width: 38, height: 32))
                                                   
        self.actionBar = NavigationCustomView(attributeLeftButtons: [attributeFirstLeftButton,
                                                                         attributeSecondLeftButton,
                                                                         attributeThreeLeftButton],
                                                  attributeRightBarButtons: [attributeFirstRightButton],
                                                  isHiddenDivider: true,
                                                  beginSpaceLeftButton: 12,
                                                  beginSpaceRightButton: 14,
                                                  continueSpaceleft: 12)
    }
    
    func activeConstraint() {
        self.setupNavigationBar()
        addSubview(avatarUserUpTusImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(actionBar)
        addSubview(numberLikedLabel)
        addSubview(statusLabel)
        addSubview(getCommentLabel)
        addSubview(timePostTusLabel)
        addSubview(fakeView)
        
        NSLayoutConstraint.activate([
            avatarUserUpTusImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarUserUpTusImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 6),
            
            usernameLabel.centerYAnchor.constraint(equalTo: avatarUserUpTusImageView.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: avatarUserUpTusImageView.rightAnchor, constant: 9),
            
            photoImageView.topAnchor.constraint(equalTo: avatarUserUpTusImageView.bottomAnchor, constant: 7),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            
            actionBar.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            actionBar.leftAnchor.constraint(equalTo: leftAnchor),
            actionBar.rightAnchor.constraint(equalTo: rightAnchor),
            actionBar.heightAnchor.constraint(equalToConstant: 35),
            
            numberLikedLabel.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 11),
            numberLikedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            numberLikedLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
            statusLabel.topAnchor.constraint(equalTo: numberLikedLabel.bottomAnchor, constant: 11),
            statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            getCommentLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 11),
            getCommentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            getCommentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),

            timePostTusLabel.topAnchor.constraint(equalTo: getCommentLabel.bottomAnchor, constant: 6),
            timePostTusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            timePostTusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            timePostTusLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        avatarUserUpTusImageView.setDimensions(width: 36, height: 36)
        photoImageView.setDimensions(width: bounds.width, height: 350)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

