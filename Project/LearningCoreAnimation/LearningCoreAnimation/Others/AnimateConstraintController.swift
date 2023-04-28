//
//  AnimateConstraint.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 26/04/2023.
//

import UIKit


class AnimateConstraintController: UIViewController {
    //MARK: - Properties
    var xAnchor: NSLayoutConstraint!
    var yAnchor: NSLayoutConstraint!
    private let redView = UIView()
    private var heartImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "tile00"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func configureHearImageView() {
        var spriteImage = [UIImage]()
        view.addSubview(heartImageView)
        
        NSLayoutConstraint.activate([
            heartImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
            heartImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        for i in 1..<29 {
            spriteImage.append(UIImage(named: "tile0\(i)")!)
        }
        self.heartImageView.animationImages = spriteImage
        self.heartImageView.animationRepeatCount = 1
        self.heartImageView.startAnimating()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white

        self.configureHearImageView()
        self.configureRedView()
    
    }
    
    func configureRedView() {
        title = "HAHAH"
        
        view.addSubview(redView)
        redView.backgroundColor = .red
        redView.translatesAutoresizingMaskIntoConstraints = false
        redView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        redView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        redView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        yAnchor = redView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        yAnchor.isActive = true
        view.layoutIfNeeded()
        
        UIView.animate(withDuration: 4, delay: 0, usingSpringWithDamping: 0.3, initialSpringVelocity: 0.3, options: .curveEaseIn) {
//            self.yAnchor.isActive = false
//            self.yAnchor = self.redView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -30)
//            self.yAnchor.isActive = true
            self.redView.backgroundColor = .green
            self.redView.backgroundColor = .blue
           // self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
