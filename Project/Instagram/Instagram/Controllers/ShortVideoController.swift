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
    private lazy var cancelButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Cancel", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(hanldeCancelButtonTapped), for: .touchUpInside)
        button.setTitleColor(.label, for: .normal)
        button.alpha = 1
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.selectedIndex = 0

    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemCyan
        
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
        
        view.addSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cancelButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            cancelButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
        cancelButton.setDimensions(width: 80, height: 82)
        
        cancelButton.backgroundColor = .red
    }
    
    //MARK: - Selectors
    @objc func hanldeCancelButtonTapped() {
        self.navigationController?.pushViewController(CommentController(), animated: true)

    }
}
//MARK: - delegate
