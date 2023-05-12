//
//  BottomProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 11/05/2023.
//

import UIKit

class BottomController: UIViewController {
    //MARK: - Properties
    private var numberRowInSection: Int!
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let titleImage: UIImage?
    
    //MARK: - View Lifecycle
    init(numberRow: Int, image: UIImage?) {
        self.numberRowInSection = numberRow
        self.titleImage = image
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
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BottomCollectionViewCell.self, forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
    }
    
    
    
    //MARK: - Selectors
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1 / 3 ))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 3)
        group.interItemSpacing = .fixed(1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
//MARK: - delegate
extension BottomController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.numberRowInSection
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as! BottomCollectionViewCell
        cell.testLabel.text = String(indexPath.row)
        return cell
    }
}

