//
//  NotificationController.swift
//  Twitter
//
//  Created by Long Bảo on 02/01/2023.
//

import UIKit

private let reuseableCell = "NotificationCell"

class NotificationController: UITableViewController {
    //MARK: - Properties
    let refeshController = UIRefreshControl()
    private var notifications: [Notification]? {
        didSet {
            tableView.reloadData()
        }
    }
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        addObserverNotification()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    

    //MARK: - Helpers
    func configureUI() {
        navigationItem.title = "Notifications"
        let appearanceNav = UINavigationBarAppearance()
        appearanceNav.backgroundColor = .white
   
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.compactAppearance = appearanceNav
        self.navigationController?.navigationBar.standardAppearance = appearanceNav
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearanceNav
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseableCell)
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        fetchNotification()
        tableView.refreshControl = refeshController
        refeshController.addTarget(self, action: #selector(handleRefeshCollectionView), for: .valueChanged)
    }
    
    func addObserverNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateFollowButtonChanged(_:)), name: NSNotification.Name("FollowButtonChanged"), object: nil)
    }
    
    func fetchNotification() {
        NotificationService.shared.fetchNotification { notifications in
            self.notifications = notifications
            self.checkIfUserIsFollowed(notifications: notifications)
        }
        
    }
    
    func checkIfUserIsFollowed(notifications: [Notification]) {
        for (index, notification) in notifications.enumerated() {
            if case .follow = notification.type {           //Hơi ảo
                let user = notification.user
                UserService.shared.checkIfUserIsFollowing(uid: user.uid) { isFollowed in
                    self.notifications?[index].user.isFollowed = isFollowed
                }
            }
        }
    }
    
    //MARK: - Selectors
    @objc func handleRefeshCollectionView() {
        self.fetchNotification()
        refeshController.endRefreshing()
    }
    
    @objc func updateFollowButtonChanged(_ notification: NSNotification) {
        guard let user = notification.userInfo?["user"] as? User,  let notifications = notifications else {
            return
        }
        for (index, notification) in notifications.enumerated() {
            if user.uid == notification.user.uid {
                let indexPath = IndexPath(row: index, section: 0)
                guard let cell = tableView.cellForRow(at: indexPath) as? NotificationCell else {return}
                self.notifications?[index].user = user
                cell.notification = self.notifications?[index]
            }
        }
        
    }

}

//MARK: - Delegate tableViewDelegate/DataSource
extension NotificationController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications?.count ?? 0 
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseableCell, for: indexPath) as! NotificationCell
        guard let notifications = notifications else {return cell}
        cell.notification = notifications[indexPath.row]
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? NotificationCell else {return}
        guard let tweetID = cell.notification?.tweetID else {return}
        TweetService.shared.fetchTweet(tweetID: tweetID) { tweet in
            let controller = TweetController(tweet: tweet)
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
    
}

//MARK: - NofiticationCellDelegate
extension NotificationController: NotificationCellDelegate {

    
    func didTapFollowButton(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        if user.isFollowed {
            UserService.shared.unfollowUser(uid: user.uid) { error in
                cell.notification?.user.isFollowed = false
            }
        } else {
            UserService.shared.followUser(uid: user.uid) { error in
                cell.notification?.user.isFollowed = true
            }
        }
    }
    
    func didTapProfileImage(_ cell: NotificationCell) {
        guard let user = cell.notification?.user else {return}
        
        let controller = ProfilelController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}
