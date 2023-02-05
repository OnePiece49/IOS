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

class UploadTwitterController: UIViewController {
    
    
    //MARK: -- Selector
    @objc func cancelUpload() {
        dismiss(animated: true)
    }
    
    @objc func handleUploadTweet() {
        guard let text = captionTextView.text else {return}
        TweetService.shared.uploadTweet(caption: text) { err in
            if let err = err {
                print("DEBUG: \(err.localizedDescription)")
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //MARK: -- Properties
    let db = Firestore.firestore()
    private let user: User
    private let captionTextView = CaptionTextView()
    
    private lazy var buttonCancel: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.addTarget(self, action: #selector(cancelUpload), for: .touchUpInside)
        return button
    }()
    
    private lazy var buttonTweet: UIButton = {
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
    
    //MARK: - Lifecycle
    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Helperss
    func configureUI() {
        let stack: UIStackView = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        
        stack.axis = .horizontal
        stack.spacing = 12
        view.addSubview(stack)
        
        view.backgroundColor = .white
        
        let appearence = UINavigationBarAppearance()
        appearence.backgroundColor = .white
        
        navigationController?.navigationBar.compactAppearance = appearence
        navigationController?.navigationBar.scrollEdgeAppearance = appearence
        navigationController?.navigationBar.standardAppearance = appearence
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: buttonCancel)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: buttonTweet)

        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, right: view.rightAnchor ,paddingTop: 16, paddingLeft: 16, paddingRight: 1)
        
    }


}
