//
//  MainTabBarController.swift
//  Twitter
//
//  Created by Long Bảo on 02/01/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore

class MainTabBarController: UITabBarController {
    
    // MARK: - Selectors
    @objc func actionButtonTapped() {
        guard let user = user else {return}
        let nav = UINavigationController(rootViewController: UploadTwitterController(user: user, config: .tweet))
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    // MARK: - Properties
    var user: User? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else {return}
            guard let feed = nav.viewControllers.first as? FeedController else {return}

            feed.user = user
        }
    }

    var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .blue
        button.setImage(UIImage(named: "new_tweet"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(actionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        checkStateUserLogin()
    }
    
    func configureUI() {
        self.view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,  paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
    }
    
    
    //MARK: - Helpers
    func configureViewController() {

        let feed = templateNavigationController(image: UIImage(named: "home_unselected"), rootViewController: FeedController(collectionViewLayout: UICollectionViewFlowLayout()))

        let explore = templateNavigationController(image: UIImage(named: "search_unselected"), rootViewController: ExploreController())
        
        let notifications = templateNavigationController(image: UIImage(named: "like_unselected"), rootViewController: NotificationController())			
        
        let conversations = templateNavigationController(image: UIImage(named: "mail"), rootViewController: ConversationController())
        
        viewControllers = [feed, explore, notifications, conversations]
    }
    
    func templateNavigationController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        return nav
    }
    
    func checkStateUserLogin() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let navLogin = UINavigationController(rootViewController: LoginController())
                navLogin.modalPresentationStyle = .fullScreen
                self.present(navLogin, animated: true, completion: nil)
            }
        } else {
            configureViewController()
            configureUI()
            fetchUser()
        }
    }
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("DEBUG: Logout failed ...")
            print("DEBUG: \(error.localizedDescription)")
        }
    }
    
    
}
