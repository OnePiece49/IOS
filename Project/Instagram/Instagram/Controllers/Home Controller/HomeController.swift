//
//  HomeController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    //MARK: - Properties
    var viewModel = HomeViewModel()
    var isPresenting: Bool = true
    let heightHeaderView: CGFloat = 60
    var currentYContentOffset: CGFloat = 0
    var numberStatus = 0
    let refreshControl = UIRefreshControl()
    
    private lazy var instagramHeaderView: InstagramHeaderView = {
        let header = InstagramHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchData()
        configureUI()
        configureProperties()
        configureRefreshControl()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.isPresenting = true
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.isPresenting = false
        self.tabBarController?.tabBar.isHidden = false
    }
    
    //MARK: - Helpers
    func fetchData() {
        viewModel.fetchDataUsers()
        viewModel.completion = {
            self.collectionView.reloadData()
        }
    }
    
    func configureUI() {
        view.backgroundColor = .systemBackground
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
        
        view.addSubview(instagramHeaderView)
        view.addSubview(collectionView)
        instagramHeaderView.backgroundColor = .systemBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instagramHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: insetTop),
            instagramHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        instagramHeaderView.setDimensions(width: view.frame.width, height: self.heightHeaderView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: instagramHeaderView.bottomAnchor, constant: -5),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func configureRefreshControl () {
        refreshControl.addTarget(self, action: #selector(handleRefreshControl), for: .valueChanged)
    }
    
    func configureProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.refreshControl = refreshControl
        collectionView.register(StoryHomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: StoryHomeCollectionViewCell.identifier)
        collectionView.register(HomeFeedCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
        collectionView.register(FooterStoryCollectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterStoryCollectionView.identifier)
    }
    
    func createStorySection() -> NSCollectionLayoutSection {
        let sizeItem: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),
                                                     heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: sizeItem)
        
        let sizeGroup: NSCollectionLayoutSize = .init(widthDimension: .absolute(82),
                                                      heightDimension: .absolute(100))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: sizeGroup,
                                                  item: item, count: 1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 2
        section.orthogonalScrollingBehavior = .continuous
        
        let sizeFooter = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                heightDimension: .absolute(0.5))
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: sizeFooter,
                                                                 elementKind: UICollectionView.elementKindSectionFooter,
                                                                 alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        return section
    }
    
    func createFeedSection() -> NSCollectionLayoutSection {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600)))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(600)),
                                                  item: item,
                                                  count: 1)
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 22
        return section
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let configuration = UICollectionViewCompositionalLayoutConfiguration()
        configuration.interSectionSpacing = 11
        let layout = UICollectionViewCompositionalLayout (sectionProvider: { section, env in
            if section == 0 {
                return self.createStorySection()
            } else  {
                return self.createFeedSection()
            }
        }, configuration: configuration)
        
        
        return layout
    }
    //MARK: - Selectors
    @objc func handleRefreshControl() {
        self.viewModel.referchData()
        self.refreshControl.endRefreshing()
    }
    
}
//MARK: - delegate
extension HomeController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryHomeCollectionViewCell.identifier,
                                                          for: indexPath) as! StoryHomeCollectionViewCell
            if  indexPath.row == 0 {
                cell.storyLabel.text = "Tin của bạn"
                cell.plusStoryImageView.isHidden = false
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier,
                                                          for: indexPath) as! HomeFeedCollectionViewCell
            cell.viewModel = HomeFeedCellViewModel(status: self.viewModel.statusAtIndexPath(indexPath: indexPath))
            cell.delegate = self
            return cell
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 20
        } else {
            return viewModel.numberStatuses
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                     withReuseIdentifier: FooterStoryCollectionView.identifier,
                                                                     for: indexPath)
        return footer
    }
    
}


extension HomeController: HomeFeedCollectionViewCellDelegate {
    func didSelectCommentButton(status: InstaStatus) {
        
    }
    
    func didSelectLikeButton(button: UIButton) {
        let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        button.tintColor = .red
        UIView.animate(withDuration: 0.15) {
            button.transform = transform
            button.setImage(UIImage(named: "heart-red"), for: .normal)
        } completion: { _ in
            button.transform = .identity
        }
    }
    

    
    func didSelectAvatar(status: InstaStatus) {
        let profileVC = ProfileController(user: status.user)

        navigationController?.pushViewController(profileVC, animated: true)
    }
    
    
}


extension HomeController: UICollectionViewDelegate {

}
