//
//  ProfileController.swift
//  Twitter
//
//  Created by Long Bảo on 20/01/2023.
//

import Foundation
import UIKit

let reuableProfilIdentifierCell = "ProfileCell"
let headerProfileCell = "ProfileCell"

class ProfilelController: UICollectionViewController {
    //MARK: - Properties
    private var user: User {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private var firstFetchData = 1
    private var selectedFilter: ProfileFilterOption = .tweets {
        didSet {collectionView.reloadData()}
    }
    
    private var tweets = [Tweet]()
    private var likedTweet = [Tweet]()
    private var repliesTweet = [Tweet]()
    
    private var currentDataSource: [Tweet] {
        get {
            switch selectedFilter {
            case .tweets:
                return tweets
            case .replies:
                return repliesTweet
            case .likes:
                return likedTweet
            }
        }
    }
 
    
    //MARK: - LifeCycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
        print("DEBUG: ProfileController Init")
    }
    
    deinit {
        print("DEBUG: ProfileController Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        
        fetchTweet()
        checkIfUserIsfollowed()
        fetchTweetLiked()
        fetchTweetReplies()
        fetchUserStats()
        configureCollectionView()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helper
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        //collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuableProfilIdentifierCell)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerProfileCell)
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        guard let tabBarHeight = tabBarController?.tabBar.frame.height else {return}
        collectionView.contentInset.bottom = tabBarHeight + 5
    }
    
    func fetchTweet() {
        TweetService.shared.fetchTweetsForUid(userID: user.uid) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserIsfollowed() {
        UserService.shared.checkIfUserIsFollowing(uid: user.uid) { [weak self] isFollowed in
            guard let strongSelf = self else {return}
            strongSelf.user.isFollowed = isFollowed
            
            self?.collectionView.reloadData()
        }
    }
    
    func fetchTweetLiked() {
        TweetService.shared.fetchLikesForUser(user: user) { tweets in
            self.likedTweet = tweets
        }
    }
    
    func fetchTweetReplies() {
        TweetService.shared.fetchRepliesTweetForUid(user: user) { tweets in
            self.repliesTweet = tweets
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { userRelation in
            guard let userRelation = userRelation else {
                return
            }
            self.user.stats = userRelation
            self.collectionView.reloadData()
        }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let y = scrollView.contentOffset.y
        let x = scrollView.contentOffset.y
        print("DEBUG: content OffSet \(x) va \(y)")
    }
    
    //MARK: - Selectors
  
}

// MARK: - UICollectionViewDataSource
extension ProfilelController {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 340)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerProfileCell, for: indexPath) as! ProfileHeader
        header.user = user
        header.delegate = self
        return header
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentDataSource.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuableProfilIdentifierCell, for: indexPath) as! TweetCell
        cell.tweet = currentDataSource[indexPath.row]
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension ProfilelController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: currentDataSource[indexPath.row])
        let height = viewModel.sizeForCaptionLabel(forWidth: view.frame.width - leftConstraintLabel - rightConstraintLabel - leftConstraintsizeProfileImageView - sizeProfileImageView).height
        return CGSize(width: view.frame.width, height: 60 + height + 10 + 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweet = currentDataSource[indexPath.row]
        let controller = TweetController(tweet: tweet)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - ProfileHeaderDelegate
extension ProfilelController: ProfileHeaderDelegate {
    func didSelect(filter: ProfileFilterOption) {
        self.selectedFilter = filter
    }
    
    func handleButtonTapped(_ header: ProfileHeader) {
        if user.isCurrentUser {
            let controller = EditProfileController(user: user)
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            controller.delegate = self
            present(nav, animated: true, completion: .none)
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) {  error in
                header.editButton.setTitle("Follow", for: .normal)
                self.user.isFollowed = false
                self.collectionView.reloadData()
                NotificationCenter.default.post(name: NSNotification.Name("FollowButtonChanged"), object: nil, userInfo: ["user": self.user])
            }
        } else {    
            UserService.shared.followUser(uid: user.uid) { [self] error in
                header.editButton.setTitle("Following", for: .normal)
                self.user.isFollowed = true
                self.collectionView.reloadData()
                NotificationService.shared.uploadNotification(user: self.user, type: .follow)
                NotificationCenter.default.post(name: NSNotification.Name("FollowButtonChanged"), object: nil, userInfo: ["user": user])
            }
        }
    }
    
    func handleDissmiss() {
        navigationController?.popViewController(animated: true)
    }
}


// Delegate EditProfileControllerDelegate
extension ProfilelController: EditProfileControllerDelegate {
    func didUpdateUserInfor() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            UserService.shared.fetchUser(uid: self.user.uid) { user in
                self.user = user
            }
            
            self.fetchTweet()
            self.checkIfUserIsfollowed()
            self.fetchTweetLiked()
            self.fetchTweetReplies()
            self.fetchUserStats()
        }
    }
}
