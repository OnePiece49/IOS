//
//  ProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import FirebaseAuth
import UIKit

class ProfileController: UIViewController {
    //MARK: - Properties
    let headerView = HeaderProfileView()
    let overlayScrollView = UIScrollView()
    let containerScrollView = UIScrollView()
    var bottomTabTripController: BottomTapTripController!
    let heightHeaderView: CGFloat = 450
    var contentOffsets: [Int: CGFloat] = [:]
    
    var bottomTabTripView: UIView {
        return bottomTabTripController.view
    }
    
    var currentIndexController: Int {
        return bottomTabTripController.currentIndex
    }
    
    var currentCollectionView: UICollectionView {
        return bottomTabTripController.currentCollectionView
    }
    
    private lazy var logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Logout", for: .normal)
        button.addTarget(self, action: #selector(handleLogoutButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
        
        activeConstraint()
        configureTabTripController()
    }
    
    func activeConstraint() {
        view.addSubview(overlayScrollView)
        view.addSubview(containerScrollView)

        headerView.translatesAutoresizingMaskIntoConstraints = false
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        overlayScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            overlayScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            overlayScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        containerScrollView.addSubview(headerView)
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: containerScrollView.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: containerScrollView.rightAnchor),
        ])
        headerView.setDimensions(width: view.frame.width, height: heightHeaderView)
        headerView.layoutIfNeeded()
        overlayScrollView.contentSize = CGSize(width: 0, height: self.headerView.frame.height + view.frame.height + 60)
        overlayScrollView.delegate = self
    }
    
    func configureTabTripController() {
        let bottomVC1 = BottomController(numberRow: 80, image: UIImage(named: "Grid Icon"))
        let bottomVC2 = BottomController(numberRow: 60, image: UIImage(named: "Tags Icon"))
        let bottomVC3 = BottomController(numberRow: 40, image: UIImage(named: "Grid Icon"))
        let configureTabBar = ConfigureTabBar(backgroundColor: .white,
                                              dividerColor: .blue,
                                              selectedBarColor: .green,
                                              notSelectedBarColor: .green)
        bottomTabTripController = BottomTapTripController(controllers: [bottomVC1,
                                                                        bottomVC2,
                                                                        bottomVC3],
                                                          configureTapBar: configureTabBar)
        
        addChild(bottomTabTripController)
        containerScrollView.addSubview(bottomTabTripView)
        bottomTabTripView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomTabTripView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bottomTabTripView.leftAnchor.constraint(equalTo: containerScrollView.leftAnchor),
            bottomTabTripView.rightAnchor.constraint(equalTo: containerScrollView.rightAnchor),
            bottomTabTripView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            bottomTabTripView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        bottomTabTripView.setDimensions(width: view.frame.width, height: view.frame.height)
        
        bottomTabTripController.controllers.forEach { controller in
            controller.collectionView.panGestureRecognizer.require(toFail: self.overlayScrollView.panGestureRecognizer)
        }
        bottomTabTripController.delegate = self
        
        for i in 0..<bottomTabTripController.controllers.count {
            self.contentOffsets[i] = 0

        }
    }

    
    //MARK: - Selectors
    @objc func handleLogoutButtonTapped() {
        try? Auth.auth().signOut()
        let loginVC = LoginController()
        loginVC.modalPresentationStyle = .overFullScreen
        present(loginVC, animated: true, completion: .none)
    }
    
}
//MARK: - delegate
extension ProfileController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yContentOffset = scrollView.contentOffset.y
        
        if yContentOffset < self.heightHeaderView  {
            containerScrollView.contentOffset = CGPoint(x: 0, y: yContentOffset)
            self.bottomTabTripController.controllers.forEach { controller in
                controller.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
            
            for i in 0..<bottomTabTripController.controllers.count {
                self.contentOffsets[i] = 0
            }
            
        } else {
            containerScrollView.contentOffset = CGPoint(x: 0, y: heightHeaderView)
            currentCollectionView.contentOffset = CGPoint(x: 0, y: yContentOffset - self.heightHeaderView)
            self.updateContentSizeOverlay(collectionView: bottomTabTripController.currentCollectionView)
            self.contentOffsets[currentIndexController] = self.currentCollectionView.contentOffset.y
        }
    }
    
    func updateContentSizeOverlay(collectionView: UICollectionView) {
        let height = heightHeaderView + collectionView.contentSize.height
        if height > view.frame.height {
            self.overlayScrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        }
    }
    
    
}

extension ProfileController: BottomTapTripControllerDelegate {
    func didMoveToNextController(collectionView: UICollectionView, currentIndex: Int) {
        collectionView.contentOffset = CGPoint(x: 0, y: self.contentOffsets[currentIndex] ?? 0)

        if overlayScrollView.contentOffset.y <= self.heightHeaderView {
            return
        }
        
        overlayScrollView.contentOffset = CGPoint(x: 0, y: collectionView.contentOffset.y + heightHeaderView)
    }
    
    
}
