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
    var isPresenting: Bool = true
    let heightHeaderView: CGFloat = 60
    var currentYContentOffset: CGFloat = 0
    var instagramStatus: [InstaStatus] = []
    var numberStatus = 0
    
    var user: User? {
        didSet {
            self.fetchStatus()
        }
    }
    
    private lazy var instagramHeaderView: InstagramHeaderView = {
        let header = InstagramHeaderView()
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureProperties()
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
    
    func configureProperties() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.bounces = false
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
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
    
    func fetchStatus() {
        guard let uid = user?.uid else {return}
        StatusService.shared.fetchTusUser(uid: uid) { status in
            guard let status = status else {
                return
            }
            
            self.instagramStatus.append(status)
            self.insertStatus()
//            self.collectionView.reloadData()
        }
    }
    
    func insertStatus() {
        let numberStatus = self.collectionView.numberOfItems(inSection: 1)
        let indexPath = IndexPath(item: numberStatus, section: 1)
        self.collectionView.insertItems(at: [indexPath])
    }
    //MARK: - Selectors
    
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
            cell.status = instagramStatus[indexPath.row]
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
            return instagramStatus.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter,
                                                                     withReuseIdentifier: FooterStoryCollectionView.identifier,
                                                                     for: indexPath)
        return footer
    }
    
}

extension HomeController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let yContentOffset = scrollView.contentOffset.y
        let transform: CGAffineTransform
        var alpha: CGFloat = 1

        if yContentOffset < heightHeaderView {
            transform = CGAffineTransform(translationX: 0, y: -yContentOffset)
            alpha = 1 - CGFloat(yContentOffset) / CGFloat(heightHeaderView)
            
        } else {
            transform = CGAffineTransform(translationX: 0, y: -heightHeaderView )
            alpha = 0
        }

            self.collectionView.transform = transform
            self.instagramHeaderView.transform = transform
            self.instagramHeaderView.alpha = alpha
            self.view.layoutIfNeeded()

        if yContentOffset < 3 {
            UIView.animate(withDuration: 0.3) {
                self.instagramHeaderView.transform = .identity
                self.collectionView.transform = .identity
                self.instagramHeaderView.alpha = 1
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.currentYContentOffset = scrollView.contentOffset.y
    }
}
