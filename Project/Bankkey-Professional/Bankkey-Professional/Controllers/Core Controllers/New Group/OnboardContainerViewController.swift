//
//  OnboardContainerViewController.swift
//  Bankkey-Professional
//
//  Created by Long Bảo on 22/03/2023.
//

import Foundation
import UIKit

class OnboardContainerViewController: UIViewController {
    private  var pages = [UIViewController]()
    private var currentIndexPage = 0 {
        didSet { print("DEBUG: \(currentIndexPage)") }
    }
    private  var currentVC: UIViewController = UIViewController()
    
    let page1 = OnboardController(imageString: "motor", titleString: "Bankey is faster, easier to use, and has a brand new look and feel that will make you feel like you are back in the 80s")
    let page2 = OnboardController(imageString: "planet", titleString: "Move your money around the world quickly and securely.")
    let page3 = OnboardController(imageString: "like", titleString: "Learn more at www.bankey.com.")
    
    //MARK: - Properties
    private let  pageController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: .none)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .purple
        addChild(pageController)
        view.addSubview(pageController.view)
        pageController.didMove(toParent: self)
        
        pageController.view.translatesAutoresizingMaskIntoConstraints = false
        pageController.dataSource = self
        pageController.delegate = self
        
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: view.topAnchor),
            self.pageController.view.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.pageController.view.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        
        pageController.setViewControllers([pages.first!], direction: .forward, animated: false, completion: nil)
        self.currentVC = pages.first!
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate PageControllerDerlegate
extension OnboardContainerViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        print("DEBUG: Before")
//        return getPreviousViewController(from: viewController)
//
//    }
//
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        print("DEBUG: After")
//
//        return getNextViewController(from: viewController)
//    }
//
//    private func getPreviousViewController(from viewController: UIViewController) -> UIViewController? {
//        guard let index = pages.firstIndex(of: viewController), index - 1 >= 0 else { return nil }
////        currentVC = pages[index - 1]
//        return pages[index - 1]
//    }
//
//    private func getNextViewController(from viewController: UIViewController) -> UIViewController? {
//        guard let index = pages.firstIndex(of: viewController), index + 1 < pages.count else { return nil }
////        currentVC = pages[index + 1]
//        return pages[index + 1]
//    }
//
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return pages.count
//    }
//
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return pages.firstIndex(of: self.currentVC) ?? 0
//    }

    
    
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return self.getPreviousPage()
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return self.getNextPage()
    }

    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.pages.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        return currentIndexPage
    }

    private func getPreviousPage() -> UIViewController? {
        if self.currentIndexPage == 0 {
//            print("DEBUG: \(currentIndexPage) a")
            return nil
            //currentPage = self.pages[currentIndexPage]
        } else {
            currentIndexPage -= 1
//            print("DEBUG: \(currentIndexPage) b")
//            currentPage = self.pages[currentIndexPage]
            return self.pages[currentIndexPage]
        }
    }

    private func getNextPage() -> UIViewController? {
        if self.currentIndexPage == (pages.count - 1) {
//            print("DEBUG: \(currentIndexPage) c")
            //currentPage = self.pages[currentIndexPage]
            return nil
        } else {
            currentIndexPage += 1
//            print("DEBUG: \(currentIndexPage) d")
//            self.currentPage = self.pages[currentIndexPage]
            return self.pages[currentIndexPage]
        }
    }
    
    
}
