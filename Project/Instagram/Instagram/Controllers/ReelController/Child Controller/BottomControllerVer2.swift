//
//  BottomControllerVer2.swift
//  Instagram
//
//  Created by Long Bảo on 30/05/2023.
//

import UIKit

struct TitleString {
    let font: UIFont
    let titleColor: UIColor
    let title: String
    
    init(title: String,
         font: UIFont = .systemFont(ofSize: 14, weight: .semibold),
         titleColor: UIColor = .label) {
        self.title = title
        self.font = font
        self.titleColor = titleColor
    }
}

struct TitleImage {
    var image: UIImage?
    let tinColor: UIColor
    let size: CGSize
    
    init(image: UIImage?,
         size: CGSize = CGSize(width: 30, height: 30),
         tinColor: UIColor = .label) {
        self.image = image
        self.tinColor = tinColor
        self.size = size
    }
}

struct TitleTabStripBottom {
    var titleString: TitleString = TitleString(title: "")
    var titleImage: TitleImage?
    
    init(titleString: TitleString) {
        self.titleString = titleString
    }
    
    init(titleImage: TitleImage) {
        self.titleImage = titleImage
    }
}

class BottomControllerVer2: UIViewController {
    //MARK: - Properties
    var bottomTabTripCollectionView: UICollectionView {
        fatalError("User must override this property")
    }
    
    var titleBottom: TitleTabStripBottom {
        return TitleTabStripBottom(titleString: TitleString(title: "48 people followers"))
    }
    
    //MARK: - View Lifecycle

    deinit {
        print("DEBUG: BottomController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    //MARK: - Helpers
    
    //MARK: - Selectors
    
}
//MARK: - delegate
class BottomFollowersController: BottomControllerVer2 {
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let titleTab = TitleTabStripBottom(titleString: TitleString(title: "48 people followers"))

    
    override var bottomTabTripCollectionView: UICollectionView {
        return self.collectionView
    }
    
    override var titleBottom: TitleTabStripBottom {
        return titleTab
    }
    
    //MARK: - View Lifecycle
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
        collectionView.showsVerticalScrollIndicator = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.register(BottomFollowerCollectionViewCell.self, forCellWithReuseIdentifier: BottomFollowerCollectionViewCell.identifier)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension BottomFollowersController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomFollowerCollectionViewCell.identifier, for: indexPath) as! BottomFollowerCollectionViewCell

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}



class BottomFollowingController: BottomControllerVer2 {
    //MARK: - Properties
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let titleTab = TitleTabStripBottom(titleString: TitleString(title: "48 people following"))

    
    override var bottomTabTripCollectionView: UICollectionView {
        return self.collectionView
    }
    
    override var titleBottom: TitleTabStripBottom {
        return titleTab
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.register(BottomFollowingCollectionViewCell.self, forCellWithReuseIdentifier: BottomFollowingCollectionViewCell.identifier)
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(80))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 1
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
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomFollowingCollectionViewCell.identifier, for: indexPath) as! BottomFollowingCollectionViewCell
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    }
}


