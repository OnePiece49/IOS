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
    
    
    private lazy var instagramHeaderView: InstagramHeaderView = {
        let header = InstagramHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
            
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.navigationController?.navigationBar.barStyle = .default
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        self.navigationItem.titleView = instagramHeaderView
        
        let appearTabBar = UITabBarAppearance()
        appearTabBar.backgroundColor = .white
        tabBarController?.tabBar.standardAppearance = appearTabBar
        tabBarController?.tabBar.scrollEdgeAppearance = appearTabBar
        
        self.activeConstraint()
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(StoryHomeCollectionViewCell.self,
                                forCellWithReuseIdentifier: StoryHomeCollectionViewCell.identifier)
        collectionView.register(HomeFeedCollectionViewCell.self,
                                forCellWithReuseIdentifier: HomeFeedCollectionViewCell.identifier)
        collectionView.register(FooterStoryCollectionView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter,
                                withReuseIdentifier: FooterStoryCollectionView.identifier)
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
    }
    
    func activeConstraint() {
        print("DEBUG: \(insetTop)")
        view.addSubview(instagramHeaderView)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            instagramHeaderView.topAnchor.constraint(equalTo: view.topAnchor, constant: self.insetTop),
            instagramHeaderView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
        instagramHeaderView.setDimensions(width: view.frame.width, height: 35)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: instagramHeaderView.bottomAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func createStorySection() -> NSCollectionLayoutSection {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = ComposionalLayout.createGroup(axis:
                                                        .horizontal,
                                                  layoutSize:
                                                        .init(widthDimension: .absolute(82), heightDimension: .absolute(100)),
                                                  item: item, count: 1)
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        
        section.interGroupSpacing = 2
        section.orthogonalScrollingBehavior = .continuous
        let footer = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(0.5)), elementKind: UICollectionView.elementKindSectionFooter, alignment: .bottom)
        section.boundarySupplementaryItems = [footer]
        return section
    }
    
    func createFeedSection() -> NSCollectionLayoutSection {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400)))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(400)),
                                                  item: item,
                                                  count: 1)
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 25
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
    
}
//MARK: - delegate
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryHomeCollectionViewCell.identifier, for: indexPath) as! StoryHomeCollectionViewCell
            if  indexPath.row == 0 {
                cell.storyLabel.text = "Tin của bạn"
                cell.plusStoryImageView.isHidden = false
            }
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeFeedCollectionViewCell.identifier, for: indexPath) as! HomeFeedCollectionViewCell
            return cell
        }
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: FooterStoryCollectionView.identifier, for: indexPath)
        return footer
    }
    
}