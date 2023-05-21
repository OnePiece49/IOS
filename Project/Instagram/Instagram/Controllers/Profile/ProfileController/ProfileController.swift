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
    var headerView = HeaderProfileView()
    let selectedSettingVC = SelectedSettingProfileController()
    let overlayScrollView = UIScrollView()
    let containerScrollView = UIScrollView()
    var bottomTabTripController: BottomTapTripController!
    var selectSettingViewTopConstraint: NSLayoutConstraint!
    var heightHeaderConstraint: NSLayoutConstraint!
    var beganPresentSettingVC = false
    let heightSelectedSettingVC: CGFloat = 475
    var contentOffsets: [Int: CGFloat] = [:]
    let headerProfileCollectionView = UICollectionView(frame: .zero,
                                                       collectionViewLayout: UICollectionViewFlowLayout())
    
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
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureTabTripController()
        configureProperties()
    }

    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.isHidden = true
        
        view.addSubview(overlayScrollView)
        view.addSubview(containerScrollView)
        view.addSubview(shadowView)
        containerScrollView.addSubview(headerProfileCollectionView)
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        overlayScrollView.translatesAutoresizingMaskIntoConstraints = false
        headerProfileCollectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            overlayScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            overlayScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            overlayScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            headerProfileCollectionView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            headerProfileCollectionView.leftAnchor.constraint(equalTo: containerScrollView.leftAnchor),
            headerProfileCollectionView.rightAnchor.constraint(equalTo: containerScrollView.rightAnchor),
            headerProfileCollectionView.heightAnchor.constraint(equalToConstant: view.frame.height),
            
            shadowView.topAnchor.constraint(equalTo: view.topAnchor),
            shadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureProperties() {
        overlayScrollView.delegate = self
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)

        headerProfileCollectionView.delegate = self
        headerProfileCollectionView.dataSource = self
        headerProfileCollectionView.register(HeaderProfileView.self,
                                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                             withReuseIdentifier: HeaderProfileView.identifier)
        headerProfileCollectionView.collectionViewLayout = self.createLayoutCollectionView()
        headerProfileCollectionView.isScrollEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            NSLayoutConstraint.deactivate([self.heightHeaderConstraint])
            
            self.heightHeaderConstraint = self.bottomTabTripView.topAnchor.constraint(equalTo: self.containerScrollView.topAnchor, constant: self.headerView.bounds.height)
            NSLayoutConstraint.activate([
                self.heightHeaderConstraint,
            ])
            self.containerScrollView.layoutIfNeeded()
            self.overlayScrollView.contentSize = CGSize(width: 0, height: self.heightHeaderConstraint.constant + self.view.frame.height + 60)
        }
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1 / 3 ))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 3)
        group.interItemSpacing = .fixed(1)
        
        let section = ComposionalLayout.createSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func configureTabTripController() {
        let bottomVC1 = BottomController(numberRow: 80, image: UIImage(named: "Grid Icon"))
        let bottomVC2 = BottomController(numberRow: 60, image: UIImage(named: "Tags Icon"))
        let bottomVC3 = BottomController(numberRow: 40, image: UIImage(named: "Grid Icon"))
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
        
        self.heightHeaderConstraint = self.bottomTabTripView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,
                                                                                  constant: self.heightSelectedSettingVC)
        NSLayoutConstraint.activate([
            heightHeaderConstraint,
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
        
        if yContentOffset < self.heightHeaderConstraint.constant  {
            containerScrollView.contentOffset = CGPoint(x: 0, y: yContentOffset)
            self.bottomTabTripController.controllers.forEach { controller in
                controller.collectionView.contentOffset = CGPoint(x: 0, y: 0)
            }
            
            for i in 0..<bottomTabTripController.controllers.count {
                self.contentOffsets[i] = 0
            }
            
        } else {
            containerScrollView.contentOffset = CGPoint(x: 0, y: self.heightHeaderConstraint.constant)
            currentCollectionView.contentOffset = CGPoint(x: 0, y: yContentOffset - self.heightHeaderConstraint.constant)
            self.updateContentSizeOverlay(collectionView: bottomTabTripController.currentCollectionView)
            self.contentOffsets[currentIndexController] = self.currentCollectionView.contentOffset.y
        }
    }
    
    func updateContentSizeOverlay(collectionView: UICollectionView) {
        let height = self.heightHeaderConstraint.constant + collectionView.contentSize.height + 60
        if height > view.frame.height {
            self.overlayScrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        }
    }
    
}

extension ProfileController: BottomTapTripControllerDelegate {
    func didMoveToNextController(collectionView: UICollectionView, currentIndex: Int) {
        collectionView.contentOffset = CGPoint(x: 0, y: self.contentOffsets[currentIndex] ?? 0)

        if overlayScrollView.contentOffset.y <= self.heightHeaderConstraint.constant {
            return
        }
        
        overlayScrollView.contentOffset = CGPoint(x: 0, y: collectionView.contentOffset.y + heightHeaderConstraint.constant)
    }
}

extension ProfileController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = UICollectionViewCell()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = headerProfileCollectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderProfileView.identifier, for: indexPath) as! HeaderProfileView
        self.headerView = header
        header.delegate = self
        return header
    }
}

extension ProfileController: HeaderProfileViewDelegate {
    func didTapthreeLineImageView() {
        UIView.animate(withDuration: 0.2) {
            self.shadowView.alpha = 0.8
        }
        
        let settingVC = SelectedSettingProfileController()
        settingVC.modalPresentationStyle = .overFullScreen
        settingVC.durationDismissing = {
            UIView.animate(withDuration: 0.2) {
                self.shadowView.alpha = 0
            }
        }
        self.present(settingVC, animated: true, completion: .none)
    }
    
    func didSelectEditButton() {
        let editProfileVC = EditProfileController()
        editProfileVC.modalPresentationStyle = .fullScreen
        self.present(editProfileVC, animated: true, completion: .none)
    }
    
    func didTapReadMoreButton() {
        headerProfileCollectionView.reloadData()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            NSLayoutConstraint.deactivate([self.heightHeaderConstraint])
            
            self.heightHeaderConstraint = self.bottomTabTripView.topAnchor.constraint(equalTo: self.containerScrollView.topAnchor, constant: self.headerView.bounds.height)
            NSLayoutConstraint.activate([
                self.heightHeaderConstraint,
            ])
            self.containerScrollView.layoutIfNeeded()
            self.overlayScrollView.contentSize = CGSize(width: 0,
                                                        height: self.heightHeaderConstraint.constant + self.view.frame.height + 60)
        }
    }
}
