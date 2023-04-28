//
//  NewsController.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 26/04/2023.
//

import UIKit

class SnapRefreshController: UIViewController {
    //MARK: - Properties
    let startingHeight: CGFloat = 90
    let shapeLayer = CAShapeLayer()
    let maxDragHeight: CGFloat = 150
    
    let lefThree = UIView()
    let lefTwo = UIView()
    let lefOne = UIView()
    let centerZero = UIView()
    let rightOne = UIView()
    let rightTwo = UIView()
    let rightThree = UIView()
    
    lazy var views: [UIView] = [
        lefThree,
        lefTwo,
        lefOne,
        centerZero,
        rightOne,
        rightTwo,
        rightThree
    ]
       
        private let backgroundView: UIImageView = {
            let iv = UIImageView(image: UIImage(named: "background"))
            iv.translatesAutoresizingMaskIntoConstraints = false
            return iv
        }()
        
        //MARK: - View Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            
            configureUI()
        }
        
        
        //MARK: - Helpers
        func configureUI() {
            shapeLayer.fillColor = UIColor.blue.cgColor
            view.layer.addSublayer(shapeLayer)
            view.backgroundColor = .darkGray
            
            let panGeture = UIPanGestureRecognizer(target: self, action: #selector(userIsDragging))
            view.addGestureRecognizer(panGeture)
                
            views.forEach { view in
                view.frame = CGRect(x: 0, y: 0, width: 4, height: 4)
                view.backgroundColor = .cyan
                self.view.addSubview(view)
            }
            
            self.layoutViewsPoint(minHeight: startingHeight, dragY: 100, dragX: view.frame.width / 2)
            self.generathPath()
        }
        
        func layoutViewsPoint(minHeight: CGFloat, dragY: CGFloat, dragX: CGFloat) {
            let minX: CGFloat = 0
            let maxX = view.frame.width
            
            let leftPath = dragX - minX
            let rightPath = maxX - dragX
            
            lefThree.center = CGPoint(x: minX, y: minHeight)
            lefTwo.center = CGPoint(x: minX + leftPath * 0.44, y: minHeight)
            lefOne.center = CGPoint(x: minX + leftPath * 0.71, y: minHeight + dragY * 0.64 )
            centerZero.center = CGPoint(x: dragX, y: minHeight + dragY * 1.36)
            rightOne.center = CGPoint(x: maxX - rightPath * 0.71, y: minHeight + dragY * 0.64)
            rightTwo.center = CGPoint(x: maxX - rightPath * 0.44 , y: minHeight)
            rightThree.center = CGPoint(x: maxX, y: minHeight)
        }
    
    func generathPath() {
        let screenWidth = view.frame.width
        
        let leftThreeCenter = lefThree.center
        let leftTwoCenter = lefTwo.center
        let leftOneCenter = lefOne.center
        let zeroCenter = centerZero.center
        let rightOneCenter = rightOne.center
        let rightTwoCenter = rightTwo.center
        let rightThreeCenter = rightThree.center
        
        let bezierPath = UIBezierPath()
        bezierPath.move(to: CGPoint(x: 0, y: 0))
        bezierPath.addLine(to: CGPoint(x: 0, y: leftThreeCenter.y))
        bezierPath.addCurve(to: leftOneCenter, controlPoint1: leftThreeCenter, controlPoint2: leftTwoCenter)
        bezierPath.addCurve(to: rightOneCenter, controlPoint1: zeroCenter, controlPoint2: zeroCenter)
        bezierPath.addCurve(to: rightThreeCenter, controlPoint1: rightOneCenter, controlPoint2: rightTwoCenter)
        bezierPath.addLine(to: CGPoint(x: screenWidth, y: 0))
        
        shapeLayer.path = bezierPath.cgPath
    }
        
        //MARK: - Selectors
        @objc func userIsDragging(gesture: UIPanGestureRecognizer) {
            if gesture.state == .ended || gesture.state == .failed || gesture.state == .cancelled || gesture.state == .began {
                print("DEBUG: \(gesture.translation(in: view))")
                
            } else {
    //            shapeLayer.frame.size.height = startingHeight + gesture.translation(in: self.view).y
                print("DEBUG: translation \(gesture.translation(in: view))")
                let dragHeight = gesture.translation(in: view).y
                
                let dragY = min(dragHeight * 0.5, maxDragHeight)
                let minHeight = startingHeight + dragHeight - dragY
            
            let dragX = gesture.location(in: view).x
            self.layoutViewsPoint(minHeight: minHeight, dragY: dragY, dragX: dragX)
                self.generathPath()
        }
    }
}
//MARK: - delegate
