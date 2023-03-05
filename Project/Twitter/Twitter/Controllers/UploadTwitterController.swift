//
//  UploadTwitterController.swift
//  Twitter
//
//  Created by Long Bảo on 08/01/2023.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
import ActiveLabel

class UploadTwitterController: UIViewController {

    //MARK: -- Properties
    let db = Firestore.firestore()
    private let user: User
    private let captionTextView = CaptionTextView()
    private let config: UploadTweetConfiguration
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var buttonCancel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelUpload), for: .touchUpInside)
        return button
    }()
    
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .twitterBlue
        button.setDimensions(width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        button.addTarget(self, action: #selector(handleUploadTweet), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .twitterBlue
        imageView.setDimensions(width: 48, height: 48)
        imageView.layer.cornerRadius = 48 / 2
        imageView.clipsToBounds = true
        
        if let imageProfileUrl = URL(string: user.profileImageURL) {
            imageView.sd_setImage(with: imageProfileUrl)
            return imageView
        }
        return imageView
    }()
    
    private let replyLabel: ActiveLabel = {
       let label = ActiveLabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.mentionColor = .twitterBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Lifecycle
    init(user: User, config: UploadTweetConfiguration) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
        print("DEBUG: UploadTweetController Init")
        handleMentionTap()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: UploadTweetController Deinit")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        switch config {
        case .tweet:
            replyLabel.text = viewModel.replyText
        case .reply(let tweet):
            replyLabel.text = viewModel.replyText
        }
    }
    
    //MARK: - Helperss
    func configureUI() {
        view.backgroundColor = .white
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .white
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        navigationController?.navigationBar.standardAppearance = appearence
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonCancel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
        
        let imageAndCaptionStack: UIStackView = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        imageAndCaptionStack.axis = .horizontal
        imageAndCaptionStack.spacing = 12
        imageAndCaptionStack.translatesAutoresizingMaskIntoConstraints = false
        let stack = UIStackView(arrangedSubviews: [replyLabel, imageAndCaptionStack])
        stack.spacing = 12
        stack.axis = .vertical
        stack.alignment = .fill
        
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor ,paddingTop: 16, paddingLeft: 16, paddingRight: 1)
        
        captionTextView.placeholderLabel.text = viewModel.placeholderText
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
    }
    
    func handleMentionTap() {
        replyLabel.handleMentionTap { mention in
            print("DEBUG: \(mention)")
        }
    }
    
    //MARK: -- Selector
    @objc func cancelUpload() {
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet() {
        guard let text = captionTextView.text else {return}
        TweetService.shared.uploadTweet(caption: text, type: config) { err in
            if let err = err {
                print("DEBUG: \(err.localizedDescription)")
            }
            
            switch self.config {
            case .tweet:
                print("DEBUG: Temp is none")
            case .reply(let tweet):
                NotificationService.shared.uploadNotification(tweet: tweet, type: .reply)
            }
                
            self.dismiss(animated: true, completion: nil)
        }
    }
    


}
