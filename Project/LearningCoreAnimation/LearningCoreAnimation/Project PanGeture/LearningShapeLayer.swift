//
//  LearningShapeLayer.swift
//  LearningCoreAnimation
//
//  Created by Long Bảo on 27/04/2023.
//

import UIKit

class LearnignShapeLayer: UIViewController {
    //MARK: - Properties
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        return view
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        containerView.frame = CGRect(x: view.frame.width / 2 - 100, y: view.frame.height / 2 - 100, width: 200, height: 200)
        view.addSubview(containerView)
        
        drawRectangle()
    }
    
    //MARK: - Selectors
    func drawRectangle() {
        let path = UIBezierPath(ovalIn: CGRect(x: 50, y: 50, width: 100, height: 100))
        
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = UIColor.blue.cgColor
        shapeLayer.fillColor = UIColor.orange.cgColor
        
        UIView.animate(withDuration: 2) {
            self.containerView.layer.addSublayer(shapeLayer)
            shapeLayer.path = path.cgPath
        }
        containerView.backgroundColor = .red
       
        
    }
}
//MARK: - delegate
