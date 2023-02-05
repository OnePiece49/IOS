//
//  ViewController.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit

class MainTabarViewController: UITabBarController {
    //MARK: - Properties
    
    //MARK: - View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }

    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .blue
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        let searchVC = UINavigationController(rootViewController: SearchViewController())
        let upcomingVC = UINavigationController(rootViewController: UpcomingViewController())
        let downloadsVC = UINavigationController(rootViewController: DowloadsViewController())
        
        homeVC.tabBarItem.image = UIImage(systemName: "house")
        searchVC.tabBarItem.image = UIImage(systemName: "magnifyingglass")
        upcomingVC.tabBarItem.image = UIImage(systemName: "play.circle")
        downloadsVC.tabBarItem.image = UIImage(systemName: "arrow.down")
        
        homeVC.title = "Home"
        upcomingVC.title = "Coming Soon"
        searchVC.title = "Top Search"
        downloadsVC.title = "Downloads"
        
        tabBar.tintColor = .red
        setViewControllers([homeVC, upcomingVC, searchVC, downloadsVC], animated: true)
    }

    //MARK: - Selectors
    
}

