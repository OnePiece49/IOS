//
//  ViewController.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 23/04/2023.
//

import UIKit

class ViewController: UIViewController {
    let redView = UIView(frame: CGRect(x: 100, y: 250, width: 140, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureUI()
 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        redView.layer.shadowColor = UIColor.blue.cgColor
        redView.layer.shadowOffset = CGSize(width: 2, height: 2)
        redView.layer.shadowOpacity = 1
        redView.layer.shadowRadius = 20
        
        
        navigationController?.pushViewController(LearningPanGetTure(), animated: true)
//        let learn = LearningPanGetTure()
//        learn.modalPresentationStyle = .fullScreen
//        present(learn, animated: true, completion: .none)
    }
    
    func moveAnimate() {
        let animtaion = CABasicAnimation()
        animtaion.fromValue = 40 + 140 / 2
        animtaion.toValue = 300
        animtaion.duration = 1
        animtaion.keyPath = "position.x"
        animtaion.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        animtaion.repeatCount = 3
        
        redView.layer.add(animtaion, forKey: "basic")
        redView.layer.position = CGPoint(x: 300, y: 100 + 100 / 2)
    }
    
    func configureUI() {
        view.addSubview(redView)
        view.backgroundColor = .white
        redView.backgroundColor = .red
    
    }

    func scaleAnimate() {
        let animation = CABasicAnimation()
        animation.fromValue = 1
        animation.toValue = 2
        animation.keyPath = "transform.scale"
        animation.duration = 1
        animation.repeatCount = 2
        redView.layer.add(animation, forKey: "scale animation")
        redView.layer.transform = CATransform3DMakeScale(2, 2, 5)
        
    }
    
    func rotateAnimate() {
        let animation = CABasicAnimation()
        animation.keyPath = "transform.rotation"
        animation.fromValue = 0
        animation.toValue = CGFloat.pi / 4
        animation.duration = 1
        
        redView.layer.add(animation, forKey: "rotate animation")
        redView.layer.transform = CATransform3DMakeRotation(CGFloat.pi / 4 , 0, 0, 1)
    }
    
    func shakingAnimate() {
        let animation = CAKeyframeAnimation()
        animation.keyPath = "position.x"
        animation.values = [0 , 20, -10, 10, 0]
        animation.keyTimes = [0, 0.16, 0.5, 0.83, 1]
        animation.duration = 2
        animation.isAdditive = true
        redView.layer.add(animation, forKey: "shake animation")
    }
}

