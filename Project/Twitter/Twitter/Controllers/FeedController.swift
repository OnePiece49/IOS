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

private let reuseIdentifier = "TweetCell"
class FeedController: UICollectionViewController {
    
    //MARK: - Properties
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
        fetchTweets()
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.isHidden = false
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
    }
    
    func configueImageProfileUser() {
        let profileView = UIImageView()
        profileView.setDimensions(width: 32, height: 32)
        profileView.layer.cornerRadius = 32 / 2
        profileView.contentMode = .scaleAspectFit
        profileView.clipsToBounds = true
        
        guard let urlImage = user?.profileImageURL else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileView)
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
    
    func fetchTweets() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        TweetService.shared.fetchTweets(uid: uid) { tweets in
            self.tweets = tweets
        }
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
}

//Mark: UICollectionViewDelegateFlowLayout
extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 110)
    }
}

//Mark: TweetCellDelegate
extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        guard let user = user else {return}
        let profileController = ProfilelController(user: user)
        navigationController?.pushViewController(profileController, animated: true)
    }
}
