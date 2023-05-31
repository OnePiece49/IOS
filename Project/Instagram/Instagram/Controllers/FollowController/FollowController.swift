//
//  FollowController.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import Foundation
import UIKit

enum BeginFollowController: Int {
    case follower = 0
    case Following = 1
}

class FollowController: UIViewController {
    //MARK: - Properties
    var navigationbar: NavigationCustomView!
    let beginPage: BeginFollowController 

    //MARK: - View Lifecycle
    init(begin: BeginFollowController) {
        self.beginPage = begin
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController?.navigationBar.isHidden = true
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true


    }

    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        self.setupNavigationBar()
        view.addSubview(navigationbar)
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        let configureTabBar = ConfigureTabBar(backgroundColor: .systemBackground,
                                              dividerColor: .black,
                                              selectedBarColor: .label,
                                              notSelectedBarColor: .systemGray,
                                              selectedBackgroundColor: .systemBackground)
                                              
        
        let followersController = BottomFollowersController(titleBottom: TitleTabStripBottom(titleString: TitleLabel(title: "48 people followers")))
        let followingController = BottomFollowingController(titleBottom: TitleTabStripBottom(titleString: TitleLabel(title: "56 people following")))
        let bottomTapTrip = BottomTapTripController(controllers: [followersController,
                                                                  followingController],
                                                    configureTapBar: configureTabBar,
                                                    beginPage: self.beginPage.rawValue)
                                                                      
        addChild(bottomTapTrip)
        view.addSubview(bottomTapTrip.view)
        didMove(toParent: self)
        
        guard let viewBottom = bottomTapTrip.view else {return}
        viewBottom.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 50),
            
            viewBottom.topAnchor.constraint(equalTo: navigationbar.bottomAnchor),
            viewBottom.leftAnchor.constraint(equalTo: view.leftAnchor),
            viewBottom.rightAnchor.constraint(equalTo: view.rightAnchor),
            viewBottom.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        view.layoutIfNeeded()
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "arrow-left"),
                                                       sizeImage: CGSize(width: 26, height: 26)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
                                                
                                                   
        self.navigationbar = NavigationCustomView(centerTitle: "m.d.garp.49",
                                              attributeLeftButtons: [attributeFirstLeftButton],
                                              attributeRightBarButtons: [],
                                              beginSpaceLeftButton: 15)
    }

    //MARK: - Selectors

    //MARK: - delegate
}
