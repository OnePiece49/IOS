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
    private var homeNaVc: UINavigationController!
    private var isFirst: Bool = true

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        checkUserSignedIn()

    }
    
    deinit {
        print("DEBUG: maintabBar deinit")
    }
    
    //MARK: - Helpers
    private func checkUserSignedIn() {
        if isFirst {
            if Auth.auth().currentUser == nil {
                let loginVC = LoginController()
                loginVC.modalPresentationStyle = .overFullScreen
                self.navigationController?.pushViewController(loginVC, animated: true)
                return
            }
            
            self.isFirst = false
            self.configureUI()
        }
    }
    
    func configureUI() {
        let homeNaVc = templateNavigationController(rootViewController: HomeController(), namedImage: "home")
        let searchNaVc = templateNavigationController(rootViewController: ExploreController(), namedImage: "search")
        let uploadFeedNavc = templateNavigationController(rootViewController: PickPhotoController(type: .uploadTus),
                                                          namedImage: "Add")
        let shortVideoNaVc = templateNavigationController(rootViewController: ShortVideoController(), namedImage: "video")
        let profileNaVc = templateNavigationController(rootViewController: ProfileController(type: .mainTabBar), namedImage: "profile")
        self.viewControllers = [homeNaVc,
                               searchNaVc,
                               uploadFeedNavc,
                               shortVideoNaVc,
                               profileNaVc]
        self.homeNaVc = homeNaVc
        self.selectedIndex = 3
        delegate = self
    }
    
    private func templateNavigationController(rootViewController: UIViewController,
                                              namedImage: String)
    -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.navigationBar.barTintColor = .white
        nav.tabBarItem.image = UIImage(named: namedImage)
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
