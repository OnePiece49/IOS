//
//  ViewController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import UIKit
import FirebaseAuth

class MainTabBarController: UITabBarController {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    private func configureUI() {
        let homeNaVc = templateNavigationController(rootViewController: HomeController(collectionViewLayout: UICollectionViewFlowLayout()), namedImage: "home")
        let searchNaVc = templateNavigationController(rootViewController: SearchController(), namedImage: "search")
        let shortVideoNaVc = templateNavigationController(rootViewController: ShortVideoController(), namedImage: "video")
        let profileNaVc = templateNavigationController(rootViewController: ProfileController(), namedImage: "profile")
        
        viewControllers = [homeNaVc, searchNaVc, shortVideoNaVc, profileNaVc]
    }
    
    private func templateNavigationController(rootViewController: UIViewController, namedImage: String) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.barTintColor = .white
        nav.tabBarItem.image = UIImage(named: namedImage)?.withTintColor(.black)
        return nav
    }
    
    
    private func checkUserSignedIn() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginController()
            loginVC.modalPresentationStyle = .overFullScreen
            present(LoginController(), animated: true, completion: .none)
        }
    }
    //MARK: - Selectors
    
}
//MARK: - delegate
