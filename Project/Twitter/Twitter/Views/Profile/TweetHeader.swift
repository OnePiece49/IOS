//
//  TweetHeader.swift
//  Twitter
//
//  Created by Long Bảo on 21/02/2023.
//

import Foundation
import UIKit
import SDWebImage
import ActiveLabel

protocol TweetHeaderActionSheetDelegate: AnyObject {
    func showActionSheet()
}

class TweetHeader: UICollectionReusableView {
    //MARK: - Properties
    lazy var profileImageViewTopAnchorToView = profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 2)
    lazy var profileImageViewTopAnchorToReplyLabel = profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 18)
    lazy var profileImageViewLeftAnchor = profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: leftConstraintsizeProfileImageView)
    weak var delegate: TweetHeaderActionSheetDelegate?
    var tweet: Tweet? {
        didSet {
            configureTweet()
        }
    }
    
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
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viet Pro"
        return label
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "@m.d.garp.49"
        return label
    }()
    
    lazy var captionLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.text = "Hello ae wibu !"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.mentionColor = .twitterBlue
        label.hashtagColor = .twitterBlue
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.textAlignment = .left
        label.text = "6:33 PM 01/28/2020"
        return label
    }()
    
    private let actionSheetButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleActionSheetTapped), for: .touchUpInside)
        return button
    }()
    
    private let retweetsLabel: UILabel = UILabel()

    
    private let likesLabel: UILabel = UILabel()

    
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

    private lazy var statsView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let divider1 = UIView()
        view.addSubview(divider1)
        divider1.translatesAutoresizingMaskIntoConstraints = false
        divider1.backgroundColor = .systemGroupedBackground
        divider1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        divider1.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        divider1.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        divider1.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [retweetsLabel, likesLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        let divider2 = UIView()
        view.addSubview(divider2)
        divider2.translatesAutoresizingMaskIntoConstraints = false
        divider2.backgroundColor = .systemGroupedBackground
        divider2.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        divider2.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        divider2.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        divider2.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        return view
    }()
    
    private let replyLabel: ActiveLabel = {
        let label = ActiveLabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.mentionColor = .twitterBlue
        return label
    }()
    
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("DEBUG: TweetHeader Init")
        configureUI()
    }
    
    deinit {
        print("DEBUG: TweetHeader Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        let labelStack = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel])
        labelStack.spacing = -6
        labelStack.axis = .vertical
        fullNameLabel.setContentHuggingPriority(UILayoutPriority.init(rawValue: 751), for: .vertical)
        let imageLabelStack = UIStackView(arrangedSubviews: [profileImageView, labelStack])
        imageLabelStack.axis = .horizontal
        imageLabelStack.spacing = 8
        
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageLabelStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .top
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: topAnchor, constant: 2).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(captionLabel)
        captionLabel.topAnchor.constraint(equalTo: imageLabelStack.bottomAnchor, constant: 20).isActive = true
        captionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        
        addSubview(dateLabel)
        dateLabel.topAnchor.constraint(equalTo: captionLabel.bottomAnchor, constant: 20).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        addSubview(statsView)
        statsView.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 8).isActive = true
        statsView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        statsView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        statsView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        let stackButton = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        addSubview(stackButton)
        stackButton.translatesAutoresizingMaskIntoConstraints = false
        stackButton.axis = .horizontal
        stackButton.topAnchor.constraint(equalTo: statsView.bottomAnchor, constant: 10).isActive = true
        stackButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 45).isActive = true
        stackButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -45).isActive = true
        stackButton.distribution = .equalCentering
        
        addSubview(actionSheetButton)
        actionSheetButton.centerYAnchor.constraint(equalTo: imageLabelStack.centerYAnchor).isActive = true
        actionSheetButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
    }
    
    func configureTweet() {
        guard let tweet = tweet else {
            return
        }
        
        let viewModel = TweetViewModel(tweet: tweet)
        captionLabel.text = tweet.caption
        fullNameLabel.text = tweet.user.fullName
        userNameLabel.text = viewModel.userNameText
        dateLabel.text = viewModel.headerTimestamp
        retweetsLabel.attributedText = viewModel.retweetsAttributedString
        likesLabel.attributedText = viewModel.likesAttributedString
        likeButton.tintColor = viewModel.likeButtonTintColor
        likeButton.setImage(viewModel.likeButtonImage, for: .normal)
        replyLabel.isHidden = viewModel.shouldHideReplyLabel
        replyLabel.text = viewModel.replyText
        
        guard let urlImage = URL(string: tweet.user.profileImageURL) else {return}
        profileImageView.sd_setImage(with: urlImage, completed: .none)
    }
    
    //MARK: - Selectors
    @objc func handleProfileImageTapped() {
        print("DEBUG: handleProfileImageTapped")
    }
    
    @objc func handleActionSheetTapped() {
        self.delegate?.showActionSheet()
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
}

//MARK: -
