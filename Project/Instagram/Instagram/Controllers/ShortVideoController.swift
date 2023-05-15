//
//  ShortVideoController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

class ShortVideoController: UIViewController {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemCyan
        
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate