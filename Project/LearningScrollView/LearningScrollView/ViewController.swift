//
//  ViewController.swift
//  LearningScrollView
//
//  Created by Long Bảo on 07/05/2023.
//

import UIKit

class ViewController: UIViewController {
    let containerScrollView = UIScrollView()
    let overlayScrollView = UIScrollView()
    var bottomVC: BottomTapTripController!
    
    var bottomView: UIView {
        return bottomVC.view
    }
    
    var contentOffset: [Int: CGFloat] = [:]
    
    let heightHeaderView: CGFloat = 300
    
    private let headerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        configureBottomController()
        configureUI()
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(overlayScrollView)
        view.addSubview(containerScrollView)
        containerScrollView.addSubview(headerView)
        
        containerScrollView.backgroundColor = .systemCyan
        containerScrollView.contentInsetAdjustmentBehavior = .never
        overlayScrollView.backgroundColor = .red
        overlayScrollView.contentInsetAdjustmentBehavior = .never
        containerScrollView.addGestureRecognizer(overlayScrollView.panGestureRecognizer)
        
        containerScrollView.translatesAutoresizingMaskIntoConstraints = false
        overlayScrollView.translatesAutoresizingMaskIntoConstraints = false
        headerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            overlayScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            overlayScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            overlayScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            overlayScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        NSLayoutConstraint.activate([
            containerScrollView.topAnchor.constraint(equalTo: view.topAnchor),
            containerScrollView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerScrollView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: containerScrollView.topAnchor),
            headerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            headerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            headerView.heightAnchor.constraint(equalToConstant: self.heightHeaderView),
            headerView.widthAnchor.constraint(equalToConstant: view.frame.width),
        ])
        
        addChild(bottomVC)
        containerScrollView.addSubview(bottomVC.view)
        didMove(toParent: self)
        
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: containerScrollView.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: containerScrollView.rightAnchor),
            bottomView.bottomAnchor.constraint(equalTo: containerScrollView.bottomAnchor),
            bottomView.heightAnchor.constraint(equalTo: view.heightAnchor),
            bottomView.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])

        overlayScrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + self.heightHeaderView)
        overlayScrollView.delegate = self
        
        bottomVC.controllers.forEach { controller in
            controller.tableView.panGestureRecognizer.require(toFail: overlayScrollView.panGestureRecognizer)
        }
    }
    
    func configureBottomController() {
        let bottomVC1 = BottomController(numberRow: 35, title: "Hello")
        let bottomVC2 = BottomController(numberRow: 60, title: "Hello ae ")
        let bottomVC3 = BottomController(numberRow: 20, title: "Hello Long ot")
        let bottomVC4 = BottomController(numberRow: 25, title: "Hello Duc Anh")
        let configureTabBar = ConfigureTabBar(backgroundColor: .systemCyan,
                                              titleColor: .white,
                                              fontSize: UIFont.systemFont(ofSize: 20, weight: .bold))
        
        self.bottomVC = BottomTapTripController(controllers: [bottomVC1, bottomVC2, bottomVC3, bottomVC4], configureTapBar: configureTabBar)
        for i in 0...bottomVC.controllers.count {
            self.contentOffset[i] = 0
        }
        self.bottomVC.delegate = self
    }
}

extension ViewController: UIScrollViewDelegate, BottomTapTripControllerDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView == self.overlayScrollView {
            let contentOffset = overlayScrollView.contentOffset
            if contentOffset.y < (self.heightHeaderView - self.insetTop) {
                self.containerScrollView.contentOffset = CGPoint(x: contentOffset.x, y: contentOffset.y)
                bottomVC.currentTabelView.contentOffset = CGPoint(x: 0, y: 0)
                bottomVC.controllers.forEach { controller in
                    controller.tableView.contentOffset = CGPoint(x: 0, y: 0)
                }
                self.contentOffset.removeAll()
                
            } else {
                bottomVC.currentTabelView.contentOffset = CGPoint(x: contentOffset.x,
                                                                  y: contentOffset.y - self.heightHeaderView + self.insetTop)
                self.containerScrollView.contentOffset = CGPoint(x: self.containerScrollView.contentOffset.x,
                                                                 y: self.heightHeaderView - self.insetTop)
                self.contentOffset[self.bottomVC.currentIndex] = bottomVC.currentTabelView.contentOffset.y
                self.updateContentSizeOverScrollView(scrollView:  bottomVC.currentTabelView)
            }
        }
    }
    
    
    func updateContentSizeOverScrollView(scrollView: UIScrollView) {
        let height = heightHeaderView + scrollView.contentSize.height
        if height > view.frame.height {
            self.overlayScrollView.contentSize = CGSize(width: self.view.frame.width, height: height)
        }
    }
    
    func didMoveToTableView(tableView: UITableView, currentIndex: Int) {
        tableView.contentOffset = CGPoint(x: 0, y: self.contentOffset[currentIndex] ?? 0)
        if tableView.contentOffset.y == 0 && overlayScrollView.contentOffset.y > self.heightHeaderView {
            overlayScrollView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y + heightHeaderView - insetTop)
            return
        }
        
        if overlayScrollView.contentOffset.y <= self.heightHeaderView {
            return
        }
        overlayScrollView.contentOffset = CGPoint(x: 0, y: tableView.contentOffset.y + heightHeaderView - insetTop)
    }
}


extension UIViewController {
    var insetTop: CGFloat {
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            let topPadding = window?.safeAreaInsets.top ?? 0
            return topPadding
        }
        
        return 0
    }
}

class BottomTableViewCell: UITableViewCell {
    //MARK: - Properties
    let numberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        return label
    }()
    static let identifier = "ProfileCollectionViewCell"
    
    //MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .blue
        addSubview(numberLabel)
        
        NSLayoutConstraint.activate([
            numberLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            numberLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
    
    //MARK: - Selectors
    
}




