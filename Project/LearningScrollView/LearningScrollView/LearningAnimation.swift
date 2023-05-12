//
//  LearningAnimation.swift
//  LearningScrollView
//
//  Created by Long Bảo on 09/05/2023.
//

import UIKit

class LearningAnimation: UIViewController {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        let replicator = CAReplicatorLayer()
        
        view.layer.addSublayer(replicator)
        replicator.instanceCount = 12
        replicator.instanceDelay = 1.5 * 1 / 12
        replicator.repeatCount = .infinity
        replicator.instanceTransform = CATransform3DMakeRotation(2 * .pi / 12, 0, 0, 1.0)

        let progreLayer = CAShapeLayer()
        
        [progreLayer].forEach { layer in
            layer.frame = CGRect(x: 75, y: 75, width: 150, height: 150)
            layer.lineWidth = 8
            layer.fillColor = UIColor.clear.cgColor
            layer.lineCap = .round
        }
        
        replicator.frame = CGRect(x: view.frame.width / 2 - 75, y: view.frame.height / 2 - 75, width: 150, height: 150)

        
        progreLayer.strokeColor = UIColor.orange.cgColor
        

        let path = UIBezierPath(
          arcCenter: CGPoint(x: 0, y: 0),
          radius: 75 - 4,
          startAngle: -(.pi / 2) - .pi / 12  ,
          endAngle:  -(.pi / 2) + .pi / 12 ,
          clockwise: true
        )
        
        progreLayer.path = path.cgPath
   
        progreLayer.add(progreLayer.addAnimationEnd(duration: 1, delay: 0), forKey: .none)
        progreLayer.add(progreLayer.addAnimationStart(duration: 1, delay: 0), forKey: .none)
        replicator.add(progreLayer.addRotation(), forKey: .none)
        replicator.addSublayer(progreLayer)
    }
    

    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension CALayer {
    func addAnimationEnd(duration: TimeInterval, delay: TimeInterval) -> CABasicAnimation {
        let shrinkEnd = CABasicAnimation(keyPath: "strokeEnd")
        shrinkEnd.fromValue = 1
        shrinkEnd.toValue = 0.5
        shrinkEnd.duration = duration // * 1.5
        shrinkEnd.autoreverses = true
        shrinkEnd.repeatCount = Float.infinity
//        shrinkEnd.fillMode = .forwards
        shrinkEnd.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return shrinkEnd
    }
    
    func addAnimationStart(duration: TimeInterval, delay: TimeInterval) -> CABasicAnimation {
        let shrinkStart = CABasicAnimation(keyPath: "strokeStart")
        shrinkStart.fromValue = 0.0
        shrinkStart.toValue = 0.5
        shrinkStart.duration = duration // * 1.5
        shrinkStart.autoreverses = true
        shrinkStart.repeatCount = Float.infinity
        shrinkStart.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
        return shrinkStart
    }
    
    func addRotation() -> CABasicAnimation {
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.byValue = CGFloat.pi*2
        rotate.duration = 10
        rotate.repeatCount = Float.infinity
        return rotate
    }
}
