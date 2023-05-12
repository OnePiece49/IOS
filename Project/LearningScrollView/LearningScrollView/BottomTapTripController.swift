//
//  BottomController.swift
//  LearningScrollView
//
//  Created by Long Bảo on 09/05/2023.
//

import UIKit

struct ConfigureTabBar {
    var backgroundColor: UIColor = .systemBlue
    var titleColor: UIColor = .white
    var backgroudTitle: UIColor = .red
    var fontSize: UIFont = .systemFont(ofSize: 14, weight: .regular)
    var dividerColor: UIColor = .red
    var selectedBarColor: UIColor = .blue
}

class BottomTapTripController: UIViewController {
    //MARK: - Properties
    let scrollView = UIScrollView()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let heightBarView: CGFloat = 80
    var configureTabBar = ConfigureTabBar()
    var delegate: BottomTapTripControllerDelegate?
    var xAnchorDivider: NSLayoutConstraint!
    var widthAnchorDivider: NSLayoutConstraint!
    
    private var currentXContentOffset: CGFloat = 0
    private var contentOffsetBeginDrag: CGFloat =  0
    private var previousContentOffset: CGFloat = 0
    
    var currentWidth: CGFloat = 0
    
    var currentIndex: Int {
        return Int(scrollView.contentOffset.x / view.frame.width)
    }
    
    var currentTabelView: UITableView {
        return controllers[currentIndex].tableView
    }
    
    var controllers: [BottomController]
    
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    //MARK: - View Lifecycle
    init(controllers: [BottomController], configureTapBar: ConfigureTabBar? = nil) {
        self.controllers = controllers
        if let configureTapBar = configureTapBar {
            self.configureTabBar = configureTapBar
        }
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
        view.backgroundColor = .white
        self.configureCollectionView()
        self.configureChildController()
        scrollView.layoutIfNeeded()
        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.bounces = false
        scrollView.contentSize.height = 0
        scrollView.backgroundColor = .blue
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
    }
    
    //MARK: - Selectors
    func configureDivider() {
        self.view.addSubview(divider)
        xAnchorDivider = divider.leftAnchor.constraint(equalTo: self.divider.leftAnchor)
        widthAnchorDivider = divider.widthAnchor.constraint(equalToConstant: 0)
        divider.backgroundColor = self.configureTabBar.dividerColor

        NSLayoutConstraint.activate([
            divider.heightAnchor.constraint(equalToConstant: 5),
            divider.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 1),
            widthAnchorDivider,
            xAnchorDivider,
        ])
    }
    
    
    func configureChildController() {
        controllers.forEach { controller in
            addChild(controller)
            self.scrollView.addSubview(controller.view)
            didMove(toParent: self)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
        }
        
        for i in 0..<(controllers.count - 1) {
            NSLayoutConstraint.activate([
                controllers[i].view.heightAnchor.constraint(equalTo: controllers[i+1].view.heightAnchor),
                controllers[i].view.widthAnchor.constraint(equalTo: controllers[i+1].view.widthAnchor),
            ])
        }
        
        NSLayoutConstraint.activate([
            controllers[0].view.heightAnchor.constraint(equalToConstant: view.frame.height - self.heightBarView - self.insetTop),
            controllers[0].view.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
        
        for i in 0..<(controllers.count) {
            NSLayoutConstraint.activate([
                controllers[i].view.topAnchor.constraint(equalTo: scrollView.topAnchor),
                controllers[i].view.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            ])
            
            if i == 0 {
                NSLayoutConstraint.activate([
                    controllers[i].view.leftAnchor.constraint(equalTo: self.scrollView.leftAnchor),
                    controllers[i].view.topAnchor.constraint(equalTo: self.scrollView.topAnchor),
                    controllers[i].view.bottomAnchor.constraint(equalTo: self.scrollView.bottomAnchor),
                    controllers[i].view.heightAnchor.constraint(equalTo: self.scrollView.heightAnchor),
                ])
            }
            
            if i == controllers.count - 1 {
                NSLayoutConstraint.activate([
                    controllers[i].view.rightAnchor.constraint(equalTo: self.scrollView.rightAnchor),
                ])
                return
            }
            
            NSLayoutConstraint.activate([
                controllers[i].view.rightAnchor.constraint(equalTo: controllers[i+1].view.leftAnchor),
            ])
        }
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
        collectionView.register(BottomCollectionViewCell.self,
                                forCellWithReuseIdentifier: BottomCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        self.configureDivider()
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: divider.bottomAnchor),
            scrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            scrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 10),
        ])
        collectionView.isPrefetchingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        
        let indexPath = IndexPath(row: 0, section: 0)
        
        DispatchQueue.main.async {
            if let cell = self.collectionView.cellForItem(at: indexPath) {
                self.widthAnchorDivider.constant = cell.frame.width
                self.currentWidth = cell.frame.width
            } else {
                self.widthAnchorDivider.constant = 0
                
            }
        }

    }
    
    func createLayout() -> UICollectionViewLayout {
        let layoutItem = NSCollectionLayoutSize(widthDimension: .estimated(30),
                                                heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: layoutItem)
        
        let layoutGroup = NSCollectionLayoutSize(widthDimension: .estimated(10),
                                                 heightDimension: .fractionalHeight(1.0))
        let group = ComposionalLayout.createGroup(axis: .vertical,
                                                  layoutSize: layoutGroup,
                                                  itemArray: [item])
        group.interItemSpacing = .fixed(2)
        
        let section = ComposionalLayout.createSection(group: group)
        section.interGroupSpacing = 2

        let configure = UICollectionViewCompositionalLayoutConfiguration()
        configure.scrollDirection = .horizontal
        configure.interSectionSpacing = 2
        let layout = UICollectionViewCompositionalLayout(section: section, configuration: configure)
        scrollView.delegate = self
        return layout
    }
    
}
//MARK: - delegate
extension BottomTapTripController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.scrollView,
            scrollView.contentOffset.x.truncatingRemainder(dividingBy: view.frame.width) != 0 {
                let xCOntentOffset = scrollView.contentOffset.x
                let currentIndexPath = IndexPath(row: self.currentIndex, section: 0)
            let currentCell = collectionView.cellForItem(at: currentIndexPath)
                
                let nexPosition = getNextFrameCell(xContentOffset: xCOntentOffset)
                NSLayoutConstraint.deactivate([self.widthAnchorDivider, self.xAnchorDivider])
                
                UIView.animate(withDuration: 0.25) {
                    self.widthAnchorDivider.constant = CGFloat(nexPosition.nextWidth)
                    self.xAnchorDivider = self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: CGFloat(nexPosition.nextX) + CGFloat(currentCell?.frame.origin.x ?? 0.0) )
                    NSLayoutConstraint.activate([
                        self.widthAnchorDivider,
                        self.xAnchorDivider,
                    ])
                    

                    self.view.layoutIfNeeded()
                }

                if nexPosition.nextX == 0 {return}
//                self.collectionView.contentOffset = CGPoint(x: Int(nexPosition.nextX), y: 0)
        }
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        self.contentOffsetBeginDrag = scrollView.contentOffset.x
    }
    
    func getNextFrameCell(xContentOffset: CGFloat) -> (nextX: Float, nextWidth: Float) {
        var nextRow: Int = currentIndex
        var percentProgress: CGFloat = 0
        var progressWidth: Float = 0
        let previousIndexPath: IndexPath!
        
        if xContentOffset - previousContentOffset > 0 {
            percentProgress  =  CGFloat(xContentOffset.truncatingRemainder(dividingBy: view.frame.width) / view.frame.width)
            nextRow += 1
            previousIndexPath = IndexPath(row: nextRow - 1, section: 0)
        } else {
            percentProgress  = 1 -  CGFloat(xContentOffset.truncatingRemainder(dividingBy: view.frame.width) / view.frame.width)
            previousIndexPath = IndexPath(row: nextRow + 1, section: 0)
        }
        
        let nextIndexPath = IndexPath(row: nextRow, section: 0)
        let firstIndePath = IndexPath(row: 0, section: 0)
        let firstCell = collectionView.cellForItem(at: firstIndePath)!
        
        let nextCell = collectionView.cellForItem(at: nextIndexPath)
        let previousCell = collectionView.cellForItem(at: previousIndexPath)
        
        guard let nextX = nextCell?.frame.origin.x else {return (0, 0)}
        guard let nextWidth = nextCell?.frame.width else {return (0, 0)}
        if nextWidth > currentWidth {                             //Kiểm tra width cell trước > hay < size cell tiếp the0
            progressWidth = abs(Float(self.currentWidth) + Float(percentProgress) * Float(nextWidth - currentWidth))
        } else {
            progressWidth = abs(Float(self.currentWidth) - Float(percentProgress) * Float(currentWidth - nextWidth))
        }
        
        guard let previousX = previousCell?.frame.origin.x else {
            return (Float(nextX - firstCell.frame.origin.x) * Float(percentProgress) , Float(progressWidth))
        }

//        if nextWidth > currentWidth {
//            progressWidth = abs(Float(self.currentWidth) + Float(percentProgress) * Float(nextWidth - currentWidth))
//        } else {
//            progressWidth = abs(Float(self.currentWidth) - Float(percentProgress) * Float(currentWidth - nextWidth))
//        }

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
        NSLayoutConstraint.deactivate([self.widthAnchorDivider, self.xAnchorDivider])
        UIView.animate(withDuration: 0.15) {
            self.widthAnchorDivider.constant = CGFloat(self.currentWidth)
            self.xAnchorDivider = self.divider.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: cell.frame.origin.x )
            NSLayoutConstraint.activate([
                self.widthAnchorDivider,
                self.xAnchorDivider,
            ])
            self.updateTabarView()
            self.view.layoutIfNeeded()
        }
        
        if (scrollView.contentOffset.x.truncatingRemainder(dividingBy: view.frame.width) == 0) {
            if self.currentXContentOffset != scrollView.contentOffset.x {
                delegate?.didMoveToTableView(tableView: self.currentTabelView, currentIndex: self.currentIndex)
            }
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.currentXContentOffset = view.frame.width * (scrollView.contentOffset.x / view.frame.width)
        
        
    }
    
    func updateTabarView(selectedRow: Int? = nil) {
        var rowSelected = currentIndex
        if let selectedRow = selectedRow  {
            rowSelected = selectedRow
        }

        for i in 0..<controllers.count {
            let tempIndexPath = IndexPath(row: i, section: 0)
            let cell = collectionView.cellForItem(at: tempIndexPath) as! Bot
            if i != rowSelected {
                cell?.backgroundColor = self.configureTabBar.backgroundColor
            } else {
                cell?.backgroundColor = self.configureTabBar.selectedBarColor
                cell.ima
            }
        }
    }
}

protocol BottomTapTripControllerDelegate {
    func didMoveToTableView(tableView: UITableView, currentIndex: Int)
}


extension BottomTapTripController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomCollectionViewCell.identifier, for: indexPath) as! BottomCollectionViewCell
        
        cell.titleLabel.text = controllers[indexPath.row].titleController
        cell.backgroundColor = self.configureTabBar.backgroundColor
        cell.titleLabel.backgroundColor = self.configureTabBar.backgroudTitle
        cell.titleLabel.textColor = self.configureTabBar.titleColor
        cell.titleLabel.font = self.configureTabBar.fontSize
        
        if indexPath.row == 0 {
            cell.backgroundColor = self.configureTabBar.selectedBarColor
        }
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
        let contentOffset = CGFloat(indexPath.row) * view.frame.width
        
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
        }
        
        self.scrollView.contentOffset = CGPoint(x: contentOffset, y: 0)
        print("DEBUG: \(scrollView.contentOffset)")
    }
    
    
}

class BottomController: UIViewController {
    //MARK: - Properties
    let tableView = UITableView()
    private var numberRowInSection: Int!
    let titleController: String
    
    
    //MARK: - View Lifecycle
    init(numberRow: Int, title: String) {
        self.numberRowInSection = numberRow
        self.titleController = title
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
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(BottomTableViewCell.self, forCellReuseIdentifier: BottomTableViewCell.identifier)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension BottomController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numberRowInSection
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: BottomTableViewCell.identifier, for: indexPath) as! BottomTableViewCell
        
        cell.configureUI()
        cell.numberLabel.text = String(indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

