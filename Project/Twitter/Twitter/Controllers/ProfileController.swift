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
    private var user: User
    
    private var tweets = [Tweet]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - LifeCycle
    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConllectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
        fetchTweet()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: - Helper
    func configureConllectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuableProfilIdentifierCell)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerProfileCell)
    }
    
    func fetchTweet() {
        let uid = user.uid
        TweetService.shared.fetchTweets(uid: uid) { tweets in
            self.tweets = tweets
        }
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
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuableProfilIdentifierCell, for: indexPath) as! TweetCell
        cell.captionLabel.text = tweets[indexPath.row].caption
        guard let imageURL = URL(string: tweets[indexPath.row].user.profileImageURL) else {return cell}
        cell.profileImageView.sd_setImage(with: imageURL, completed: nil)
        cell.infoLabel.text = tweets[indexPath.row].user.fullName
        return cell
    }
}

// MARK: - UICollectionViewFlowLayout
extension ProfilelController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - UICollectionViewFlowLayout
extension ProfilelController: ProfileHeaderDelegate {
    func handleDissmiss() {
        navigationController?.popViewController(animated: true)
    }
}

