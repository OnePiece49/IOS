//
//  File.swift
//  Twitter
//
//  Created by Long Bảo on 19/01/2023.
//

import Foundation
import UIKit
import SDWebImage

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
}

class TweetCell: UICollectionViewCell {

    
    //MARK: - Properties
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet? {
        didSet {
            configureTweet()
        }
    }
    
    lazy var profileImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .twitterBlue
        image.setDimensions(width: 30, height: 30)
        image.clipsToBounds = true
        image.layer.cornerRadius = 30 / 2
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Vietdz vkl"
        return label
    }()
    
    var infoLabel = UILabel()
    
    lazy var commentButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "comment"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleCommentTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var retweetButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "retweet"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleRetweetTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var likeButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "like"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleLikeTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var shareButton: UIButton = {
       let button = UIButton()
        button.setImage(UIImage(named: "share"), for: .normal)
        button.setDimensions(width: 20, height: 20)
        button.tintColor = .darkGray
        button.addTarget(self, action: #selector(handleShareTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    @objc func handleProfileImageTapped() {
        self.delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        print("A")
    }
    
    @objc func handleRetweetTapped() {
        print("B")
    }
    
    @objc func handleLikeTapped() {
        print("C")
    }
    
    @objc func handleShareTapped() {
        print("D")
    }
    
    
    //MARK: - Hepers
    func configureUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        
        let stackLabel = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        addSubview(stackLabel)
        infoLabel.text = "Viet vippro"
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.axis = .vertical
        stackLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: 12).isActive = true
        stackLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        stackLabel.spacing = 4
        
        let underlineView = UIView()
        addSubview(underlineView)
        underlineView.backgroundColor = .systemGroupedBackground
        underlineView.translatesAutoresizingMaskIntoConstraints = false
        underlineView.heightAnchor.constraint(equalToConstant:  1).isActive = true
        underlineView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        underlineView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        underlineView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -3).isActive = true
        
        let stackButton = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        addSubview(stackButton)
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.axis = .horizontal
        stackButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        stackButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 45).isActive = true
        stackButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -45).isActive = true
        stackButton.distribution = .equalCentering
    }
    
    func configureTweet() {
        guard let tweet = tweet else {return}
        
        let tweetViewModel = TweetViewModel(tweet: tweet)
        
        self.infoLabel.text = tweet.user.fullName
        self.captionLabel.text = tweet.caption
        self.infoLabel.attributedText = tweetViewModel.userTextInfor
        self.profileImageView.sd_setImage(with: tweetViewModel.profileImage, completed: nil)
    }
}
