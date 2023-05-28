//
//  StatusDetailController.swift
//  Instagram
//
//  Created by Long Bảo on 27/05/2023.
//

import UIKit


class StatusDetailController: UIViewController {
    //MARK: - Properties
    var collectionView: UICollectionView!
    let refreshControl = UIRefreshControl()
    var navigationbar: NavigationCustomView!
    let status: InstaStatus
    let currentUser: User
    
    //MARK: - View Lifecycle
    init(status: InstaStatus, user: User) {
        self.status = status
        self.currentUser = user
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: self.createCollectionViewLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        setupNavigationbar()
        view.addSubview(collectionView)
        view.addSubview(navigationbar)
        view.backgroundColor = .systemBackground
        
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 55),
            
            collectionView.topAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: 10),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.refreshControl = refreshControl
        collectionView.register(HomeFeedCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
    }
    
    func setupNavigationbar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(systemName: "chevron.backward"),
                                                       sizeImage: CGSize(width: 20, height: 25),
                                                       tincolor: .label) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }


        let navigationBar = NavigationCustomView(centerTitle: "Explore",
                                                 attributeLeftButtons: [attributeFirstLeftButton],
                                                 attributeRightBarButtons: [],
                                                 beginSpaceLeftButton: 12,
                                                 beginSpaceRightButton: 12)
        self.navigationbar = navigationBar
    }
    
    func createCollectionViewLayout() -> UICollectionViewLayout {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600)))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600)),
                                                  item: item,
                                                  count: 1)
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 22
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension StatusDetailController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier,
                                                      for: indexPath) as! HomeFeedCollectionViewCell
        cell.viewModel = HomeFeedCellViewModel(status: self.status)
        cell.delegate = self
        return cell
    }
}

extension StatusDetailController: HomeFeedCollectionViewCellDelegate {
    func didSelectCommentButton(cell: HomeFeedCollectionViewCell, status: InstaStatus) {
        let commentVC = CommentController(status: status, currentUser: currentUser)
        commentVC.modalPresentationStyle = .overFullScreen
        commentVC.delegate = cell.self
        self.tabBarController?.navigationController?.pushViewController(commentVC, animated: true)
    }
    
    func didSelectAvatar(status: InstaStatus) {
        let profileVC = ProfileController(user: status.user, type: .other)

        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}
