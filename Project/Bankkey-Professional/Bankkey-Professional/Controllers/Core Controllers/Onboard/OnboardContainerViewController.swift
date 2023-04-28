//
//  OnboardContainerViewController.swift
//  Bankkey-Professional
//
//  Created by Long Bảo on 22/03/2023.
//

import Foundation
import UIKit

class OnboardContainerViewController: UIViewController {
    private lazy var pages = [UIViewController]()
    private let picker = UIImagePickerController()
    private var currentIndexPage = 0 {
        didSet { print("DEBUG: \(currentIndexPage)") }
    }
    private  var currentVC: UIViewController = UIViewController()
    
    let page1 = OnboardController(imageString: "motor", titleString: "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in the 80s")
    let page2 = OnboardController(imageString: "planet", titleString: "Move your money around the world quickly and securely.")
    let page3 = OnboardController(imageString: "like", titleString: "Learn more at www.bankey.com.")
    
    //MARK: - Properties
    private lazy var  pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    lazy var navigationControllerViet = UINavigationController(rootViewController: pageController)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.toolbar.isTranslucent = false
        configureUI()
    }
    
    private lazy var button1: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Vietdz", for: .normal)
        return button
    }()
    
    private lazy var button2: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Vietdz2", for: .normal)
        return button
    }()
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .purple
        addChild(navigationControllerViet)
        view.addSubview(navigationControllerViet.view)
        navigationControllerViet.didMove(toParent: self)
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 30))
        myView.backgroundColor = .systemRed
    
        pageController.navigationController?.navigationBar.topItem?.titleView = myView
        myView.addSubview(button1)
        myView.addSubview(button2)
        
        navigationControllerViet.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.dataSource = self
        pageController.delegate = self
        
        NSLayoutConstraint.activate([
            self.navigationControllerViet.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.navigationControllerViet.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.navigationControllerViet.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.navigationControllerViet.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        
        pageController.setViewControllers([pages[1]], direction: .forward, animated: false, completion: nil)
        
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate PageControllerDerlegate
extension OnboardContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        print("DEBUG: viewControllerBefore")
        return self.getPreviousPage(viewController: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        print("DEBUG: viewControllerAfter")
        return self.getNextPage(viewController: viewController)
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        print("DEBUG: presentationIndex")
        return 0
    }
    
    
    private func getNextPage(viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else {
            return nil
        }
        
        return pages[index + 1]
    }
    
    private func getPreviousPage(viewController: UIViewController) -> UIViewController? {
        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else {
            return nil
        }
        
        return pages[index - 1]
    }
    
    
}

extension OnboardContainerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print("DEBUG: kakakak")
    }
}

extension OnboardContainerViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
    }
}
