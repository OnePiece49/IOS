//
//  TweetController.swift
//  Twitter
//
//  Created by Long Bảo on 21/02/2023.
//

import Foundation
import UIKit

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "TweetHeader"

class TweetController: UICollectionViewController {
    //MARK: - Properties
    private let tweet: Tweet
    private var actionSheet: ActionSheetLauncher!
    private let layout = UICollectionViewFlowLayout()
    var replies: [Tweet]? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK: - Lifecycle
    init(tweet: Tweet) {
        self.tweet = tweet
        print("DEBUG: Tweet Controller Init")
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: TweetController Deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureConllectionView()
        fetchRepliesTweet()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = false
    }
    
    
    //MARK: - Helpers
    func configureConllectionView() {
        let viewModel = TweetViewModel(tweet: tweet)
        let heightForCaption = viewModel.sizeForCaptionLabel(forWidth: self.view.frame.width).height
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: heightForCaption + 195 + 40)
        layout.itemSize = CGSize(width: self.view.frame.width, height: 120)
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
    }
    
    func fetchRepliesTweet() {
        TweetService.shared.fetchRepliesTweet(tweet: tweet) { tweets in
            self.replies = tweets
        }
    }
    
    fileprivate func showActionSheet(user: User) {
        actionSheet = ActionSheetLauncher(user: user)
        actionSheet.delegate = self
        self.actionSheet.show()
    }
    //MARK: - Selectors
}

//MARK: - Delegate DataSource
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        guard let replies = replies else {return cell}
        cell.tweet = replies[indexPath.row]
        return cell
    }
    
    
}

//MARK: - Delegate UICollectionViewFlowLayout
extension TweetController {
    ///Cái này ko chạy, wtf vô lý, phải sử dụng property layout
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 340)
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        header.tweet = tweet
        header.delegate = self
        return header
    }
}

//MARK: - Delegate TweetHeaderActionSheetDelegate
extension TweetController: TweetHeaderActionSheetDelegate {
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(user: tweet.user)
        } else {
            UserService.shared.checkIfUserIsFollowing(uid: tweet.user.uid) {  isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(user: user)
            }
        }
    }
}

//MARK: - Delegate ActionSheetLauncherDelegate
extension TweetController: ActionSheetLauncherDelegate {
    func didSelect(option: ActionSheetOptions) {
        switch option {
        case .follow(let user):
            UserService.shared.followUser(uid: user.uid) { _ in
            }
        case .unfollow(let user):
            UserService.shared.unfollowUser(uid: user.uid) { _ in
                
            }
        case .report:
            print("DEBUG: report tweet")
        case .delete:
            print("delete tweet")
        }
    }
    
    
}
