//
//  LearningPanGesture.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 27/04/2023.
//

import UIKit

class LearningPanGetTure: UIViewController {
    //MARK: - Properties
    let containerView = UIView(frame: CGRect(x: 100, y: 250, width: 200, height: 150))
    let subView = UIView()
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(containerView)
        containerView.addSubview(subView)
        containerView.backgroundColor = .red
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            subView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            subView.widthAnchor.constraint(equalTo: containerView.widthAnchor, constant: -130),
            subView.heightAnchor.constraint(equalTo: containerView.heightAnchor, constant: -70),
        ])
        subView.backgroundColor = .systemBlue
        subView.center = containerView.center
        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(userIsDragging)))
    }
    
    //MARK: - Selectors
    @objc func userIsDragging(_ sender: UIPanGestureRecognizer) {
        if sender.state == .changed {
            let location = sender.location(in: UIWindow())
            let locationFinger = sender.translation(in: self.view)
            //self.view.transform = CGAffineTransform(translationX: locationFinger.x, y: locationFinger.y)
        }
    }
    
}
//MARK: - delegate
