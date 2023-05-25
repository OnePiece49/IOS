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
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkUserSignedIn()
    }
    
    
    
    //MARK: - Helpers
    private func checkUserSignedIn() {
        if Auth.auth().currentUser == nil {
            let loginVC = LoginController()
            loginVC.modalPresentationStyle = .overFullScreen
            present(LoginController(), animated: true, completion: .none)
            return
        }
        
        self.configureUI()
        
    }
    
    private func configureUI() {
        let searchNaVc = templateNavigationController(rootViewController: ExploreController(), namedImage: "search")
        let uploadFeedNavc = templateNavigationController(rootViewController: PickPhotoController(type: .uploadTus),
                                                          namedImage: "Add")
        let shortVideoNaVc = templateNavigationController(rootViewController: ShortVideoController(), namedImage: "video")
        let profileNaVc = templateNavigationController(rootViewController: ProfileController(), namedImage: "profile")
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

    //MARK: - Selectors
    
}
//MARK: - delegate
extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if viewController == self.homeNaVc && self.selectedViewController == self.homeNaVc {
            
            guard let homeVC =  self.homeNaVc.viewControllers.first as? HomeController,
                  homeVC.isPresenting else {return}
            
            UIView.animate(withDuration: 0.3) {
                homeVC.collectionView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
            }
        }
    }
}
