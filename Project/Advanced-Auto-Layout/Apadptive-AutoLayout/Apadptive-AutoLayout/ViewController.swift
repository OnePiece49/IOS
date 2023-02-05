//
//  ViewController.swift
//  Apadptive-AutoLayout
//
//  Created by Long Bảo on 13/01/2023.
//

import UIKit

class ViewController: UIViewController {
    
    let widthView = CGFloat(414)
    var topAnchor = NSLayoutConstraint()
    var CenterYAnchor = NSLayoutConstraint()
    let playerView = PlayerView()
    let stack = makeStackView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        registerForOrientationChanges()
    }
    
    func configureUI() {
        let imageRush = makeImageView()
        let playerView = playerView.makePlayerView()
        
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        stack.addArrangedSubview(imageRush)
        stack.addArrangedSubview(playerView)
        imageRush.widthAnchor.constraint(equalTo: imageRush.heightAnchor).isActive = true

        stack.alignment = .fill
    }
    
    func registerForOrientationChanges() {
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    @objc func rotated() {
        if UIDevice.current.orientation.isLandscape {
            playerView.topAnchorConstant.isActive = false
            playerView.centerAnchor.isActive = true
            stack.axis = .horizontal
        } else {
            playerView.topAnchorConstant.isActive = true
            playerView.centerAnchor.isActive = false
            stack.axis = .vertical
        }
    }
    

}

