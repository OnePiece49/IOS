//
//  BottomTabTripControllerVer2.swift
//  Instagram
//
//  Created by Long Bảo on 30/05/2023.
//

import UIKit

class BottomTapTripControllerVer2: UIViewController {
    //MARK: - Properties
    let scrollView = UIScrollView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let heightBarView: CGFloat = 44
    var configureTabBar = ConfigureTabBar()
    weak var delegate: BottomTapTripControllerDelegate?
    var xAnchorDivider: NSLayoutConstraint!
    var widthAnchorDivider: NSLayoutConstraint!
    var spacingControllers: CGFloat = 1
    var newestControllerContrainted = 0
    var rightConstraintScrollView: NSLayoutConstraint!
    
    private var currentXContentOffset: CGFloat = 0
    private var previousContentOffset: CGFloat = 0
    var currentWidth: CGFloat = 0
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var currentIndex: Int {
        return Int(scrollView.contentOffset.x / view.frame.width)
    }
    
    var currentCollectionView: UICollectionView {
        return controllers[currentIndex].bottomTabTripCollectionView
    }
    
    var controllers: [BottomControllerVer2]
    
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .green
        return view
    }()
    
    //MARK: - View Lifecycle
    init(controllers: [BottomControllerVer2], configureTapBar: ConfigureTabBar? = nil) {
        self.controllers = controllers
        if let configureTapBar = configureTapBar {
            self.configureTabBar = configureTapBar
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: BottomTaptripController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        self.configureCollectionView()
        self.addFirstChildController()
        
        scrollView.backgroundColor = .white
        scrollView.layoutIfNeeded()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentSize.height = 0
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    //MARK: - Selectors
    func configureDivider() {
        self.view.addSubview(divider)
        xAnchorDivider = divider.leftAnchor.constraint(equalTo: self.view.leftAnchor)
        widthAnchorDivider = divider.widthAnchor.constraint(equalToConstant: view.frame.width / CGFloat(controllers.count))
        divider.backgroundColor = self.configureTabBar.dividerColor

        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 2),
            divider.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 1),
            widthAnchorDivider,
            xAnchorDivider,
        ])
    }
    
    func addConstraintChildController(index: Int) {
        if index > self.newestControllerContrainted && index < controllers.count {
            for i in (self.newestControllerContrainted + 1)...index {
                addChild(controllers[i])
                scrollView.addSubview(controllers[i].view)
                didMove(toParent: self)
                controllers[i].view.translatesAutoresizingMaskIntoConstraints = false

                NSLayoutConstraint.activate([
                    controllers[i].view.heightAnchor.constraint(equalTo: controllers[i-1].view.heightAnchor),
                    controllers[i].view.widthAnchor.constraint(equalTo: controllers[i-1].view.widthAnchor),
                    
                    controllers[i].view.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                    controllers[i-1].view.rightAnchor.constraint(equalTo: controllers[i].view.leftAnchor, constant: -self.spacingControllers),
                    controllers[i].view.heightAnchor.constraint(equalToConstant: view.frame.height - self.heightBarView - self.insetTop),
                ])
                
                if i == self.controllers.count - 1 {
                    NSLayoutConstraint.deactivate([self.rightConstraintScrollView])
                    NSLayoutConstraint.activate([
                        controllers[i].view.rightAnchor.constraint(equalTo: scrollView.rightAnchor, constant: (CGFloat(self.controllers.count - 1)) * self.spacingControllers)
                    ])
                    scrollView.layoutIfNeeded()
                    self.fakeView.removeFromSuperview()
                }
            }
            self.newestControllerContrainted = index
        }

    }
    
    func addFirstChildController() {
        addChild(controllers[0])
        self.scrollView.addSubview(controllers[0].view)
        didMove(toParent: self)
        controllers[0].view.translatesAutoresizingMaskIntoConstraints = false
        
        scrollView.addSubview(fakeView)
        let width = self.view.bounds.width
        
        self.rightConstraintScrollView =  fakeView.leftAnchor.constraint(equalTo: controllers[0].view.rightAnchor, constant: CGFloat((Double(controllers.count) - 1.3)) * width)
        NSLayoutConstraint.activate([
            controllers[0].view.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
            controllers[0].view.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
            
            controllers[0].view.heightAnchor.constraint(equalToConstant: view.frame.height - self.heightBarView - self.insetTop),
            controllers[0].view.widthAnchor.constraint(equalTo: view.widthAnchor),
            self.rightConstraintScrollView,
            
            fakeView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            fakeView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            fakeView.widthAnchor.constraint(equalToConstant: 40),
            fakeView.heightAnchor.constraint(equalToConstant: 50),
        ])

        scrollView.layoutIfNeeded()
    }
    
    func configureCollectionView() {
        view.addSubview(scrollView)
        view.addSubview(collectionView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: heightBarView),
        ])
        
        collectionView.collectionViewLayout = createLayout()
        collectionView.register(BottomTabBarCollectionViewCell.self,
                                forCellWithReuseIdentifier: BottomTabBarCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.configureDivider()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 1),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
        ])
        collectionView.isPrefetchingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isScrollEnabled = false
        collectionView.layoutIfNeeded()
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.async {
            NSLayoutConstraint.deactivate([self.widthAnchorDivider])
            if let cell = self.collectionView.cellForItem(at: indexPath) {
                self.widthAnchorDivider.constant = cell.frame.width
                self.currentWidth = cell.frame.width
                NSLayoutConstraint.activate([
                    self.widthAnchorDivider,
                ])
            } else {
                self.widthAnchorDivider.constant = 0
            }
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                              heightDimension: .absolute(self.heightBarView))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(self.heightBarView))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: self.controllers.count)
        group.interItemSpacing = .fixed(2)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 2
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
}
//MARK: - delegate
extension BottomTapTripControllerVer2: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("DEBUG: lmm \(scrollView.contentSize) and \(scrollView.frame)")
    
        let temp = Float(scrollView.contentOffset.x.truncatingRemainder(dividingBy: view.frame.width).truncatingRemainder(dividingBy: self.spacingControllers))
        if scrollView.contentOffset.x > self.currentXContentOffset {
            self.addConstraintChildController(index: self.currentIndex + 1)
        }
        
        if scrollView == self.scrollView,
           temp != 0 || self.spacingControllers == 0  {
                let xCOntentOffset = scrollView.contentOffset.x
                let currentIndexPath = IndexPath(row: self.currentIndex, section: 0)
                let currentCell = collectionView.cellForItem(at: currentIndexPath)
                
                let nexPosition = getNextFrameCell(xContentOffset: xCOntentOffset)
                NSLayoutConstraint.deactivate([self.widthAnchorDivider, self.xAnchorDivider])
                
            UIView.animate(withDuration: 0.13) {
                    self.widthAnchorDivider.constant = CGFloat(nexPosition.nextWidth)
                    self.xAnchorDivider = self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(nexPosition.nextX) + CGFloat(currentCell?.frame.origin.x ?? 0.0) )
                    NSLayoutConstraint.activate([
                        self.widthAnchorDivider,
                        self.xAnchorDivider,
                    ])
                    
                    self.view.layoutIfNeeded()
                }

        }
    }

    func getNextFrameCell(xContentOffset: CGFloat) -> (nextX: Float, nextWidth: Float) {
        var nextRow: Int = currentIndex
        var percentProgress: CGFloat = 0
        var progressWidth: Float = 0
        let previousIndexPath: IndexPath!
        
        if xContentOffset - previousContentOffset > 0 {
            percentProgress = CGFloat(xContentOffset.truncatingRemainder(dividingBy: view.frame.width) / view.frame.width)
            previousIndexPath = IndexPath(row: nextRow, section: 0)
            nextRow += 1
        } else {
            percentProgress  = 1 -  CGFloat(xContentOffset.truncatingRemainder(dividingBy: view.frame.width) / view.frame.width)
            previousIndexPath = IndexPath(row: nextRow + 1, section: 0)
        }
        
        let nextIndexPath = IndexPath(row: nextRow, section: 0)
        let firstIndePath = IndexPath(row: 0, section: 0)
        let firstCell = collectionView.cellForItem(at: firstIndePath)!
        
        let nextCell = collectionView.cellForItem(at: nextIndexPath)
        let previousCell = collectionView.cellForItem(at: previousIndexPath)
        
        guard let nextX = nextCell?.frame.origin.x, let nextWidth = nextCell?.frame.width else {
            if xContentOffset - previousContentOffset > 0 {
                return (Float(previousCell?.frame.width ?? 0) * Float(percentProgress),
                        Float(previousCell!.frame.width  * (1 - percentProgress)))
            } else {
                return (0, Float(previousCell!.frame.width  * (1 - percentProgress)))
            }
        }

        
        if nextWidth > currentWidth {                             //Kiểm tra width cell trước > hay < size cell tiếp the0
            progressWidth = abs(Float(self.currentWidth) + Float(percentProgress) * Float(nextWidth - currentWidth))
        } else {
            progressWidth = abs(Float(self.currentWidth) - Float(percentProgress) * Float(currentWidth - nextWidth))
        }
        
        guard let previousX = previousCell?.frame.origin.x else {
            return (Float(nextX - firstCell.frame.origin.x) * Float(percentProgress) , Float(progressWidth))
        }

        if xContentOffset - previousContentOffset > 0 {
            return (Float(nextX - previousX) * Float(percentProgress) , Float(progressWidth))
        } else {
            return (Float(previousX - nextX) * (1 - Float(percentProgress)) , Float(progressWidth))
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let indexPath = IndexPath(row: currentIndex, section: 0)
        let cell = collectionView.cellForItem(at: indexPath)!
        self.currentWidth = cell.frame.width
        self.previousContentOffset = scrollView.contentOffset.x
        NSLayoutConstraint.deactivate([self.widthAnchorDivider,
                                       self.xAnchorDivider])
        
        UIView.animate(withDuration: 0.13) {
            self.widthAnchorDivider.constant = self.currentWidth
            self.xAnchorDivider = self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: cell.frame.origin.x)
            NSLayoutConstraint.activate([
                self.widthAnchorDivider,
                self.xAnchorDivider,
            ])
            
            self.updateTabarView()
            self.view.layoutIfNeeded()
        }
        
        UIView.animate(withDuration: 0.05, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 0.8, options: .curveLinear) {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + CGFloat(self.currentIndex) * self.spacingControllers, y: 0)
        }

        if self.currentXContentOffset != scrollView.contentOffset.x {
            delegate?.didMoveToNextController(collectionView: self.currentCollectionView,
                                     currentIndex: self.currentIndex)
            self.currentXContentOffset = scrollView.contentOffset.x
        
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.currentXContentOffset = scrollView.contentOffset.x
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            UIView.animate(withDuration: 0.1,
                           delay: 0.0,
                           usingSpringWithDamping: 1.0,
                           initialSpringVelocity: 0.8,
                           options: .curveLinear) {
                scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x + CGFloat(self.currentIndex) * self.spacingControllers,
                                                   y: 0)
            }
        }
    }
    
    func updateTabarView(selectedRow: Int? = nil) {
        var rowSelected = currentIndex
        if let selectedRow = selectedRow  {
            rowSelected = selectedRow
        }

        for i in 0..<controllers.count {
            let tempIndexPath = IndexPath(row: i, section: 0)
            let cell = collectionView.cellForItem(at: tempIndexPath) as! BottomTabBarCollectionViewCell
//            if i != rowSelected {
//                cell.optionImage.tintColor = self.configureTabBar.notSelectedBarColor
//                cell.backgroundColor = self.configureTabBar.backgroundColor
//            } else {
//                cell.optionImage.image?.withTintColor(self.configureTabBar.selectedBarColor, renderingMode: .alwaysTemplate)
//                cell.backgroundColor = self.configureTabBar.selectedBackgroundColor
//            }
        }
    }
}


extension BottomTapTripControllerVer2: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomTabBarCollectionViewCell.identifier, for: indexPath) as! BottomTabBarCollectionViewCell
        cell.backgroundColor = self.configureTabBar.backgroundColor
        cell.titleBottom = controllers[indexPath.row].titleBottom

        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return controllers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)!
        let x = cell.frame.origin.x
        let width = cell.frame.width
        let contentOffset = CGFloat(indexPath.row) * view.frame.width + CGFloat(indexPath.row) * self.spacingControllers
        
        updateTabarView(selectedRow: indexPath.row)
        
        NSLayoutConstraint.deactivate([self.widthAnchorDivider, self.xAnchorDivider])
        UIView.animate(withDuration: 0.25) {
            self.widthAnchorDivider.constant = CGFloat(width)
            self.xAnchorDivider = self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: x)
            NSLayoutConstraint.activate([
                self.widthAnchorDivider,
                self.xAnchorDivider,
            ])
            
            self.view.layoutIfNeeded()
            self.scrollView.contentOffset = CGPoint(x: contentOffset, y: 0)
        }
        
        self.addConstraintChildController(index: indexPath.row)
        delegate?.didMoveToNextController(collectionView: self.currentCollectionView,
                                          currentIndex: self.currentIndex)
        
    }
    
    
    
}
