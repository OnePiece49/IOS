//
//  CoreAnimation.swift
//  LearningCoreGraphic
//
//  Created by Tiến Việt Trịnh on 27/06/2023.
//

import UIKit


class CoreAnimationController: UIViewController {
    //MARK: - Properties
    private lazy var actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.frame = .init(x: view.frame.midX - 25, y: 60, width: 50, height: 50)
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(handelAction), for: .touchUpInside)
        return button
    }()
        
    private lazy var redView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "bp"))
        iv.frame = CGRect(x: 50, y: 200, width: 150, height: 150)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
//        iv.layer.cornerRadius = 75
//        iv.layer.masksToBounds = true
        return iv
    }()

    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
//        moveAnimate()
//        scaleAnimate()
//        rotateAnimate()
        keyframeAnimte()
    }
    
    func configureUI() {
        view.addSubview(redView)
        view.addSubview(actionButton)
        redView.backgroundColor = .red
        view.backgroundColor = .white
        addShadow()
    }
    
    
    //MARK: - Helpers
    func moveAnimate() {
        let animation = CABasicAnimation(keyPath: "position.x")
        animation.fromValue = 150 / 2 + 50
        animation.toValue = 150 / 2 + 50 + 200
        animation.duration = 2
        animation.repeatCount = 2

        redView.layer.add(animation, forKey: "move.x")
        redView.layer.position.x = 150 / 2 + 50 + 200
    }
    
    func scaleAnimate() {
        let move = CABasicAnimation(keyPath: "position.x")
        move.fromValue = 150 / 2 + 50
        move.toValue = 150 / 2 + 50 + 200
        move.duration = 2
        move.repeatCount = 2

        let scale = CABasicAnimation(keyPath: "transform.scale.x")
        scale.fromValue = 0.2
        scale.toValue = 2
        scale.duration = 2

        redView.layer.add(move, forKey: "move.x")
        redView.layer.add(scale, forKey: "scale")
        redView.layer.position.x = 150 / 2 + 50 + 200
        
//        let transformX = CGAffineTransform(translationX: 150, y: 0)
//        let transformScale = CGAffineTransform(scaleX: 0.2, y: 1.5)
//        let combine = transformX.concatenating(transformScale)
//        UIView.animate(withDuration: 2) {
//            self.redView.transform = combine
//        }
    }
    
    func rotateAnimate() {
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = CGFloat.pi * 2
        rotate.duration = 2

        
        let scaleX = CABasicAnimation(keyPath: "transform.scale.x")
        scaleX.fromValue = 1
        scaleX.toValue = 2
        scaleX.duration = 2
        scaleX.isCumulative = true

        
        let scaleY = CABasicAnimation(keyPath: "transform.scale.y")
        scaleY.fromValue = 1
        scaleY.toValue = 2
        scaleY.duration = 2
        scaleY.isCumulative = true

        redView.layer.add(scaleY, forKey: "scaleY")
        redView.layer.add(scaleX, forKey: "scaleX")
        redView.layer.add(rotate, forKey: "rotate.z")
    }
    
    func keyframeAnimte() {
        let keyframeX = CAKeyframeAnimation(keyPath: "transform.scale.x")
        keyframeX.values = [1, 2 , 1, 0.5, 1]
        keyframeX.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        keyframeX.duration = 2
        keyframeX.repeatDuration = .infinity

        let keyframeY = CAKeyframeAnimation(keyPath: "transform.scale.y")
        keyframeY.values = [1, 2 , 1, 0.5, 1]
        keyframeY.keyTimes = [0, 0.25, 0.5, 0.75, 1]
        keyframeY.duration = 2
        keyframeY.repeatDuration = .infinity

        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.fromValue = 0
        rotate.toValue = CGFloat.pi * 2
        rotate.duration = 2
        rotate.repeatDuration = .infinity

        redView.layer.add(keyframeX, forKey: "scaleX")
        redView.layer.add(keyframeY, forKey: "scaleY")
        redView.layer.add(rotate, forKey: "rotate")
    }
    
    func addShadow() {
        redView.layer.shadowColor = UIColor.red.cgColor
        redView.layer.shadowOffset = CGSize(width: 0, height: 0)
        redView.layer.shadowOpacity = 1
        redView.layer.shadowRadius = 15
    }
    
    
    //MARK: - Selectors
    @objc func handelAction() {
        keyframeAnimte()
    }
    
}
//MARK: - delegate
