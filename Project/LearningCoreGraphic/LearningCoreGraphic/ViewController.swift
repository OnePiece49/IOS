//
//  ViewController.swift
//  LearningCoreGraphic
//
//  Created by Long Bảo on 23/06/2023.
//

import UIKit


class ViewController: UIViewController {
    //MARK: - Properties
    let drawView = DrawView(frame: .zero)
    let shapeView = UIView(frame: .zero)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    //MARK: - Helpers
    func configureUI() {
        addDrawView()
        addShapeLayer()
        addArcLayer()
    }
    
    func addDrawView() {
        view.addSubview(drawView)
        drawView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            drawView.heightAnchor.constraint(equalToConstant: 300),
            drawView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            drawView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            drawView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        view.layoutIfNeeded()
    }
    
    func addShapeLayer() {
        var startPoint: CGPoint = CGPoint(x: 0, y: 0)
        let cornelRadius: CGFloat = 35
        
        let shape = CAShapeLayer()
        let path = UIBezierPath(arcCenter: CGPoint(x: view.frame.midX, y: 150), radius: 90, startAngle: .pi * 2 / 3, endAngle: .pi / 3, clockwise: true)
        
        path.cgPath.applyWithBlock { point in
            if point.pointee.type == .moveToPoint {
                startPoint = point.pointee.points[0]
            }
        }
        
        path.addLine(to: CGPoint(x: path.currentPoint.x + 80 - cornelRadius, y: path.currentPoint.y))
        path.addQuadCurve(to: CGPoint(x: path.currentPoint.x + cornelRadius, y: path.currentPoint.y + cornelRadius),
                          controlPoint: CGPoint(x: path.currentPoint.x + cornelRadius, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y + 80 - cornelRadius))
        path.addLine(to: CGPoint(x: startPoint.x - 80, y: path.currentPoint.y))
        path.addLine(to: CGPoint(x: path.currentPoint.x, y: path.currentPoint.y - 80 + cornelRadius))
        path.addQuadCurve(to: CGPoint(x: path.currentPoint.x + cornelRadius, y: startPoint.y), controlPoint: CGPoint(x: path.currentPoint.x, y: startPoint.y))
        path.addLine(to: startPoint)

        shape.path = path.cgPath
        shape.lineWidth = 3
        shape.strokeColor = UIColor.gray.cgColor
        shape.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(shape)
    }
    
    func addArcLayer() {
        let shape = CAShapeLayer()
        let path = UIBezierPath()
        
        path.move(to: CGPoint(x: 90, y: 450))
        path.addLine(to: CGPoint(x: 350, y: 450))
//        path.addArc(withCenter: CGPoint(x: 350, y: 400),
//                    radius: 25,
//                    startAngle: .pi / 2,
//                    endAngle: -.pi / 2,
//                    clockwise: false)
//        path.addLine(to: CGPoint(x: 350, y: 350))
//        path.addLine(to: CGPoint(x: 90, y: 350))
//        path.addArc(withCenter: CGPoint(x: 90, y: 400),
//                    radius: 25,
//                    startAngle: -.pi / 2,
//                    endAngle: .pi / 2,
//                    clockwise: false)
        path.close()
        
        shape.path = path.cgPath
        shape.strokeColor = UIColor.blue.cgColor
        shape.lineWidth = 3
        shape.fillColor = UIColor.yellow.cgColor
        
        self.view.layer.addSublayer(shape)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
