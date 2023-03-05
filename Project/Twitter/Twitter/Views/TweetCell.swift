//
//  File.swift
//  Twitter
//
//  Created by Long Bảo on 19/01/2023.
//

import Foundation
import UIKit
import SDWebImage
import ActiveLabel

protocol TweetCellDelegate: AnyObject {
    func handleProfileImageTapped(_ cell: TweetCell)
    func handleReplyTapped(_ cell: TweetCell)
    func handleLikeTapped(_ cell: TweetCell)
}

let leftConstraintLabel: CGFloat = 12
let rightConstraintLabel: CGFloat = 12
let sizeProfileImageView: CGFloat = 48
let leftConstraintsizeProfileImageView: CGFloat = 12

class TweetCell: UICollectionViewCell {
    //MARK: - Properties
    lazy var profileImageViewTopAnchorToView = profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2)
    lazy var profileImageViewTopAnchorToReplyLabel = profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 18)
    lazy var profileImageViewLeftAnchor = profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstraintsizeProfileImageView)
    weak var delegate: TweetCellDelegate?
    
    var tweet: Tweet? {
        didSet {
            configureTweet()
        }
    }
    
    /// Có UITapGestureRecognizer: chú ý
    lazy var profileImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .twitterBlue
        image.setDimensions(width: 48, height: 48)
        image.clipsToBounds = true
        image.layer.cornerRadius = 48 / 2
        image.translatesAutoresizingMaskIntoConstraints = false
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true
        return image
    }()
    
    lazy var captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
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
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemCyan
        configureUI()
        handleMentionTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Hepers
    func configureUI() {
        backgroundColor = .white
        addSubview(profileImageView)
        addSubview(replyLabel)
        replyLabel.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        replyLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        profileImageViewTopAnchorToView.isActive = true
        profileImageViewTopAnchorToReplyLabel.isActive = true
        profileImageViewLeftAnchor.isActive = true
        profileImageViewTopAnchorToView.priority = UILayoutPriority(999)
        profileImageViewTopAnchorToReplyLabel.priority = UILayoutPriority(999)
        
        let stackLabel = UIStackView(arrangedSubviews: [infoLabel, captionLabel])
        addSubview(stackLabel)
        stackLabel.translatesAutoresizingMaskIntoConstraints = false
        stackLabel.axis = .vertical
        stackLabel.leftAnchor.constraint(equalTo: profileImageView.rightAnchor, constant: leftConstraintLabel).isActive = true
        stackLabel.topAnchor.constraint(equalTo: profileImageView.topAnchor).isActive = true
        stackLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -rightConstraintLabel).isActive = true
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
        stackButton.topAnchor.constraint(equalTo: stackLabel.bottomAnchor, constant: 15).isActive = true
        stackButton.leftAnchor.constraint(equalTo: stackLabel.leftAnchor).isActive = true
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
        likeButton.tintColor = tweetViewModel.likeButtonTintColor
        likeButton.setImage(tweetViewModel.likeButtonImage, for: .normal)
        
        if tweetViewModel.shouldHideReplyLabel {
            profileImageViewTopAnchorToView.isActive = true
            profileImageViewTopAnchorToReplyLabel.isActive = false
            replyLabel.text = tweetViewModel.replyText
        } else {
            replyLabel.text = tweetViewModel.replyText
            profileImageViewTopAnchorToView.isActive = false
            profileImageViewTopAnchorToReplyLabel.isActive = true
        }
    }
    
    func handleMentionTapped() {
        captionLabel.handleMentionTap { mention in
            print("DEBUG: \(mention)")
        }
    }
    
    //MARK: - Selectors
    @objc func handleProfileImageTapped() {
        self.delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleCommentTapped() {
        delegate?.handleReplyTapped(self)
    }
    
    @objc func handleRetweetTapped() {
        print("B")
    }
    
    @objc func handleLikeTapped() {
        delegate?.handleLikeTapped(self)
    }
    
    @objc func handleShareTapped() {
        print("D")
    }
    
    

}

