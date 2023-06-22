//
//  ViewController.swift
//  LearningAVPlayer
//
//  Created by Long Bảo on 21/06/2023.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    //MARK: - Properties
    var child1: Children!
    var child2: Children!
    var child3: Children!
    
    var playerContainerView: UIView!
    private var playerView: PlayerView!
    
    private let videoURL = "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4"
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        learningObserve()
        configureUI()
        playVideo()
    }

    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        setUpPlayerContainerView()
        setUpPlayerView()
    }
    
    private func setUpPlayerContainerView() {
        playerContainerView = UIView()
        playerContainerView.backgroundColor = .black
        view.addSubview(playerContainerView)
        playerContainerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playerContainerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            playerContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            playerContainerView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),
        ])
    }
    
    private func setUpPlayerView() {
        playerView = PlayerView(frame: .zero)
        view.addSubview(playerView)
            
        playerView.translatesAutoresizingMaskIntoConstraints = false
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerContainerView.widthAnchor, multiplier: 16/9).isActive = true
        playerView.centerYAnchor.constraint(equalTo: playerContainerView.centerYAnchor).isActive = true
        
        view.layoutIfNeeded()
        
    }
    
    func playVideo() {
        guard let url = URL(string: videoURL) else { return }
        playerView.play(with: url)
    }
    
    //MARK: - Selectors
    func learningObserve() {
        self.child1 = Children()
        self.child2 = Children.init()
        self.child2.child = Children.init()
        
        self.child2.setValue("DucAnh", forKey: "name")
        self.child2.setValue(11, forKey: "age")
        self.child2.setValue("HuyNguNgoc", forKeyPath: "child.name")
        self.child2.setValue(15, forKeyPath: "child.age")
    }
}
//MARK: - delegate
