//
//  FeedController.swift
//  Twitter
//
//  Created by Long Bảo on 02/01/2023.
//

import UIKit
import SDWebImage
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore


class FeedController: UICollectionViewController {
    
    //MARK: - Properties
    private let reuseIdentifier = "TweetCell"
    let refreshScroll = UIRefreshControl()
    var user: User? {
        didSet {
            configueImageProfileUser()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchFollowingAndSelfTweet()
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
    }
    
    deinit {
        print("DEBUG: Feed Controller Deinit")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBlue
        navigationItem.title = "New Feeds"
        let appearanceNav = UINavigationBarAppearance()
        appearanceNav.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        self.navigationItem.titleView = imageView
        
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.compactAppearance = appearanceNav
        self.navigationController?.navigationBar.standardAppearance = appearanceNav
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearanceNav
        
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
        
        configureRefreshControl()
        collectionView.refreshControl = refreshScroll
    }
    
    func configureRefreshControl () {
       refreshScroll.addTarget(self, action:
                                          #selector(handleRefreshControl),
                                          for: .valueChanged)
    }
    
    func configueImageProfileUser() {
        let profileView = UIImageView()
        profileView.setDimensions(width: 32, height: 32)
        profileView.layer.cornerRadius = 32 / 2
        profileView.contentMode = .scaleToFill
        profileView.clipsToBounds = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileViewNavigationBarTap))
        profileView.addGestureRecognizer(tap)
        profileView.isUserInteractionEnabled = true
        
        guard let urlImage = user?.profileImageURL else {
            return
        }
        
        profileView.sd_setImage(with: URL(string: urlImage))
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileView)
        
        let fakeView = UIImageView()
        fakeView.setDimensions(width: 32, height: 32)
        fakeView.layer.cornerRadius = 32 / 2
        fakeView.contentMode = .scaleAspectFit
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: fakeView)
    }
    
    func fetchAllTweets() {
        TweetService.shared.fetchAllTweets { tweets in
            self.tweets = tweets
            self.checkIfUserLikedTweet(tweets: self.tweets)
        }
    }
    
    func checkIfUserLikedTweet(tweets: [Tweet]) {
        for (index, tweet) in tweets.enumerated() {
            TweetService.shared.checkIfUserLikedTweet(tweet: tweet) { didLiked in
                guard didLiked == true else {return}
                self.tweets[index].didLike = true
            }
        }
    }
    
    func fetchFollowingAndSelfTweet() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        TweetService.shared.fetchFollwingAndSelfTweet(uid: uid) { tweets in
            self.tweets = tweets
            self.checkIfUserLikedTweet(tweets: tweets)
        }
    }
    
    //MARK: - Selectors
    @objc func handleRefreshControl() {
        self.fetchFollowingAndSelfTweet()
        self.refreshScroll.endRefreshing()
    }
    
    @objc func handleProfileViewNavigationBarTap() {
        guard let user = user else {
            return
        }

        let profileController = ProfilelController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}

//MARK: - UICollectionViewDelegate/DataSource
extension FeedController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = tweets[indexPath.row]
        cell.delegate = self
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let tweetController = TweetController(tweet: tweets[indexPath.row])
        self.navigationController?.pushViewController(tweetController, animated: true)
    }
}

//Mark: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.sizeForCaptionLabel(forWidth: view.frame.width - leftConstraintLabel - rightConstraintLabel - leftConstraintsizeProfileImageView - sizeProfileImageView).height
        return CGSize(width: view.frame.width, height: 60 + height + 10 + 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerProfileCell, for: indexPath) as! ProfileHeader
        return header
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > -200 {
            
        }
    }
}

//Mark: TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleLikeTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        TweetService.shared.likeTweet(tweet: tweet) {
            let likes = tweet.didLike ? tweet.likes - 1 : tweet.likes + 1
            cell.tweet?.didLike.toggle()
            cell.tweet?.likes = likes
            
            for (index, tweet) in self.tweets.enumerated() {
                if tweet.tweetID == cell.tweet?.tweetID {
                    self.tweets[index].likes = likes
                    self.tweets[index].didLike.toggle()
                }
            }
            //Only upload notification if tweet is being liked
            guard !tweet.didLike else {return}
            NotificationService.shared.uploadNotification(tweet: tweet, type: .like)
        }
    }
    			
    func handleReplyTapped(_ cell: TweetCell) {
        guard let tweet = cell.tweet else {return}
        let controller = UploadTwitterController(user: tweet.user, config: .reply(tweet))
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: .none)
    }
    
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = cell.tweet?.user else {return}
        let profileController = ProfilelController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
