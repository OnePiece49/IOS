//
//  SearchController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

class SearchController: UIViewController {
    //MARK: - Properties
    private lazy var logoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "logo"), for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .label
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        button.addTarget(self, action: #selector(handleVC), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemGray
        view.addSubview(logoButton)
        NSLayoutConstraint.activate([
            logoButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ])
        logoButton.setDimensions(width: 120, height: 60)
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
    }
    
    //MARK: - Selectors
    @objc func handleVC() {

    }
    
}
//MARK: - delegate
