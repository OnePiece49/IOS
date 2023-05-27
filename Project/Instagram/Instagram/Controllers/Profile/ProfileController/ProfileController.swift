//
//  ProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import FirebaseAuth
import UIKit
import SDWebImage

class ProfileController: UIViewController {
    //MARK: - Properties
    let viewModel = ProfileViewModel()
    var headerViewController = HeaderProfileViewController()
    let selectedSettingVC = SettingProfileController()
    let overlayScrollView = UIScrollView()
    let containerScrollView = UIScrollView()
    var bottomTabTripController: BottomTapTripController!
    let refreshControl = UIRefreshControl()
    var selectSettingViewTopConstraint: NSLayoutConstraint!
    
    var beganPresentSettingVC = false
    let heightSelectedSettingVC: CGFloat = 475
    var contentOffsets: [Int: CGFloat] = [:]
    var isSelectingUsername: Bool = false
    var viewTransform: CGAffineTransform = .identity
    
    func updateUI() {
        guard let user = self.viewModel.user else {return}
        self.headerViewController.viewModel = HeaderProfileViewModel(user: user)
    }
    
    var heightHeaderView: CGFloat {
        headerViewController.view.frame.height
    }
    
    var bottomTabTripView: UIView {
        return bottomTabTripController.view
    }
    
    var currentIndexController: Int {
        return bottomTabTripController.currentIndex
    }
    
    var currentCollectionView: UICollectionView {
        return bottomTabTripController.currentCollectionView
    }
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()
    
    //MARK: - View Lifecycle
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel.user = user
        self.fetchDataForAnotherUser()
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
        fetchDataForCurrentUser()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: ProfileController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
        self.configureUI()
        print("DEBUG: \(self) profile")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Helpers
    func configureUI() {
        addChild(headerViewController)
        containerScrollView.addSubview(headerViewController.view)
        didMove(toParent: self)
        view.backgroundColor = .systemBackground
        view.addSubview(overlayScrollView)
        view.addSubview(containerScrollView)
        view.addSubview(shadowView)
        headerViewController.view.translatesAutoresizingMaskIntoConstraints = false

        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        overlayScrollView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            overlayScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerViewController.view.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            headerViewController.view.leftAnchor.constraint(equalTo: containerScrollView.leftAnchor),
            headerViewController.view.rightAnchor.constraint(equalTo: containerScrollView.rightAnchor),
            
            shadowView.topAnchor.constraint(equalTo: view.topAnchor),
            shadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureProperties() {
        headerViewController.delegate = self
        overlayScrollView.delegate = self
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        overlayScrollView.showsVerticalScrollIndicator = false
        containerScrollView.showsVerticalScrollIndicator = false
        overlayScrollView.refreshControl = refreshControl
        self.containerScrollView.layoutIfNeeded()
        self.overlayScrollView.contentSize = CGSize(width: 0,
                                                    height: self.heightHeaderView + self.view.frame.height + 60)
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }

    
    func configureTabTripController() {
        let bottomVC1 = BottomController(image: UIImage(named: "grid"), type: .image)
        let bottomVC2 = BottomController(image: UIImage(named: "video-1"),  type: .image)
        let bottomVC3 = BottomController(image: UIImage(named: "tag-black"), type: .image)
        bottomVC1.user = viewModel.user
        bottomVC2.user = viewModel.user
        bottomVC3.user = viewModel.user
        
        let configureTabBar = ConfigureTabBar(backgroundColor: .white,
                                              dividerColor: .black,
                                              selectedBarColor: .green,
                                              notSelectedBarColor: .green,
                                              selectedBackgroundColor: .white)
        bottomTabTripController = BottomTapTripController(controllers: [bottomVC1,
                                                                        bottomVC2,
                                                                        bottomVC3],
                                                          configureTapBar: configureTabBar)
        
        addChild(bottomTabTripController)
        containerScrollView.addSubview(bottomTabTripView)
        bottomTabTripView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            bottomTabTripView.topAnchor.constraint(equalTo: headerViewController.view.bottomAnchor),
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

    func fetchDataForAnotherUser() {
        self.viewModel.hasFollowedUser()
        self.viewModel.completionFetchMainInfo = { [weak self] in
            self?.updateUI()
            self?.configureProperties()
            self?.configureTabTripController()
        }
        
        self.viewModel.completionFetchSubInfo = { [weak self] in
            self?.updateUI()
        }
    }
    
    func fetchDataForCurrentUser() {
        viewModel.fetchUser()
        viewModel.completionFetchMainInfo = { [weak self] in
            self?.updateUI()
            self?.configureProperties()
            self?.configureTabTripController()
        }
        
        self.viewModel.completionFetchSubInfo = { [weak self] in
            self?.updateUI()
        }
    }
    
    //MARK: - Selectors
    @objc func handleRefreshControl() {
        self.viewModel.referchData()
        self.refreshControl.endRefreshing()
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
            containerScrollView.contentOffset = CGPoint(x: 0, y: self.heightHeaderView)
            currentCollectionView.contentOffset = CGPoint(x: 0, y: yContentOffset - self.heightHeaderView)
            self.updateContentSizeOverlay(collectionView: bottomTabTripController.currentCollectionView)
            self.contentOffsets[currentIndexController] = self.currentCollectionView.contentOffset.y
        }
    }
    
    func updateContentSizeOverlay(collectionView: UICollectionView) {
        let height = self.heightHeaderView + collectionView.contentSize.height + 60
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


extension ProfileController: HeaderProfileDelegate {
    func didSelectUsernameButton() {
        let viewTransform = CGAffineTransform(scaleX: 0.88, y: 0.88)
        self.tabBarController?.view.clipsToBounds = true
        
        let switchAccountVC = SwitchAccountController(imageUser: self.headerViewController.getAvatarImage())
        switchAccountVC.modalPresentationStyle = .overFullScreen
        switchAccountVC.delegate = self
        switchAccountVC.durationDismissing = {
            UIView.animate(withDuration: 0.2) {
                self.tabBarController?.view.layer.cornerRadius = 0
                self.tabBarController?.navigationController?.view.transform = .identity
                self.shadowView.alpha = 0
            }
        }
        self.present(switchAccountVC, animated: false, completion: .none)
        UIView.animate(withDuration: 0.2) {
            self.tabBarController?.navigationController?.view.transform = viewTransform
            self.shadowView.alpha = 0.8
            self.tabBarController?.view.layer.cornerRadius = 20
        }
    }
    
    func didTapthreeLineImageView() {
        UIView.animate(withDuration: 0.2) {
            self.shadowView.alpha = 0.8
        }
        
        let settingVC = SettingProfileController()
        settingVC.modalPresentationStyle = .overFullScreen

        settingVC.durationDismissing = {
            UIView.animate(withDuration: 0.2) {
                self.shadowView.alpha = 0
            }
        }
        self.present(settingVC, animated: false, completion: .none)
    }
    
    func didSelectEditButton() {
        guard let user = viewModel.user else {return}
        let editProfileVC = EditProfileController(user: user, image: headerViewController.getAvatarImage())
        editProfileVC.delegate = self
        self.navigationController?.pushViewController(editProfileVC, animated: true)
    }
}

extension ProfileController: SwitchAccountDelegate {
    func didSelectLogoutButton(_ viewController: BottomSheetViewCustomController) {
        try? Auth.auth().signOut()
        let loginVC = LoginController()
        navigationController?.pushViewController(loginVC, animated: true)
        
        viewController.animationDismiss()
    }
    
    func didSelectCreateNewAccountButton(_ viewController: BottomSheetViewCustomController) {
        self.navigationController?.pushViewController(RegisterController(), animated: true)
        viewController.animationDismiss()
    }
}

extension ProfileController: EditProfileDelegate {
    func didUpdateProfile(user: User, image: UIImage?) {
        self.viewModel.user = user
        self.headerViewController.updateAvatar(image: image)
        
    }

}
