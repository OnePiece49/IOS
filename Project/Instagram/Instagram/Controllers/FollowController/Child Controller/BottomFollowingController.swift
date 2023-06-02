//
//  BottomFollowingController.swift
//  Instagram
//
//  Created by Long Bảo on 31/05/2023.
//

import UIKit

protocol BottomFollowDelegate: AnyObject {
    func didSelectUser(user: User)
    func didTapRemoveButton(user: User)
    func didSelectFollowButton(user: User)
}

extension BottomFollowDelegate {
    func didSelectUser(user: User) {}
}

class BottomFollowingController: BottomController {
    //MARK: - Properties
    weak var delegate: BottomFollowDelegate?
    var viewModel: FollowingViewModel? {
        didSet {
            self.fetchData()
        }
    }
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    override var bottomTabTripCollectionView: UICollectionView {
        return self.collectionView
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    //MARK: - Helpers
    func fetchData() {
        self.viewModel?.fetchData()
        self.viewModel?.completionFecthData = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    func configureUI() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.register(BottomFollowingCollectionViewCell.self,
                                forCellWithReuseIdentifier: BottomFollowingCollectionViewCell.identifier)
        collectionView.register(HeaderFollowView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HeaderFollowView.identifier)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(70))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 1)
        
        let section = ComposionalLayout.createSection(group: group)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension BottomFollowingController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberUsers ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomFollowingCollectionViewCell.identifier, for: indexPath) as! BottomFollowingCollectionViewCell
        guard let viewModel = viewModel else {return cell}
        cell.viewModel = FollowCellViewModel(user: viewModel.userAtIndexPath(indexPath: indexPath), type: .following, fromType: viewModel.fromType)
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let viewModel = viewModel else {return}

        self.delegate?.didSelectUser(user: viewModel.userAtIndexPath(indexPath: indexPath))
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader,
                                                                     withReuseIdentifier: HeaderFollowView.identifier,
                                                                     for: indexPath) as! HeaderFollowView
        header.type = .following
        return header
    }
}


extension BottomFollowingController: BottomFollowingCellDelegate {
    func didSelectFollowButton(cell: BottomFollowingCollectionViewCell, user: User) {
        viewModel?.completionUpdateFollowUser = {
            cell.updateFollowButtonAfterTapped()
            self.delegate?.didSelectFollowButton(user: self.viewModel!.user)
        }
        
        if user.isFollowed {
            cell.viewModel?.user.isFollowed = false
            cell.updateFollowButtonAfterTapped()
            viewModel?.unfollowUser(user: user)

        } else {
            cell.viewModel?.user.isFollowed = true
            cell.updateFollowButtonAfterTapped()
            viewModel?.followUser(user: user)
        }
    }
    
    
}
