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
    private lazy var homeNaVc = templateNavigationController(rootViewController: HomeController(), namedImage: "home")
    private lazy var searchNaVc = templateNavigationController(rootViewController: SearchController(), namedImage: "search")
    private lazy var uploadFeedNavc = templateNavigationController(rootViewController: PickPhotoController(), namedImage: "Add")
    private lazy var shortVideoNaVc = templateNavigationController(rootViewController: ShortVideoController(), namedImage: "video")
    private lazy var profileNaVc = templateNavigationController(rootViewController: ProfileController(), namedImage: "profile")
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    private func configureUI() {

        viewControllers = [homeNaVc,
                           searchNaVc,
                           uploadFeedNavc,
                           shortVideoNaVc,
                           profileNaVc]
        delegate = self
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
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.homeNaVc && self.selectedViewController == self.homeNaVc {
            
            guard let homeVC =  self.homeNaVc.viewControllers.first as? HomeController,
                  homeVC.isPresenting else {return}
            
            UIView.animate(withDuration: 0.4) {
                homeVC.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
}
