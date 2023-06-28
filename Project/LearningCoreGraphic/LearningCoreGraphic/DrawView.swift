//
//  drawView.swift
//  LearningCoreGraphic
//
//  Created by Tiến Việt Trịnh on 25/06/2023.
//

import UIKit

class DrawView: UIView {
    //MARK: - Properties
    override func draw(_ rect: CGRect) {
        let heightMouth: CGFloat = 30
        let cornelBottom: CGFloat = 35
        let cornelRadius: CGFloat = 70
        let cornelCenter: CGFloat = 130
        let widthRect = rect.width
        let heightRect = rect.height
        let context = UIGraphicsGetCurrentContext()
        let startPoint = CGPoint(x: 0, y: heightRect)
        
        context?.move(to: startPoint)
        context?.addLine(to: CGPoint(x: 0, y: cornelRadius))
        context?.addQuadCurve(to: CGPoint(x: widthRect / 3 , y: cornelRadius),
                              control: CGPoint(x: widthRect / 6, y: -cornelRadius))
        context?.addQuadCurve(to: CGPoint(x:  2 * widthRect / 3 , y: cornelRadius),
                              control: CGPoint(x: widthRect / 2, y: cornelRadius + 2 * (cornelCenter - cornelRadius)))
        context?.addQuadCurve(to: CGPoint(x:  widthRect , y: cornelRadius),
                              control: CGPoint(x: 5 * widthRect / 6, y: -cornelRadius))
        context?.addLine(to: CGPoint(x: widthRect, y: heightRect))
        
        context?.addQuadCurve(to: CGPoint(x: 3 / 4 * widthRect , y: heightRect),
                              control: CGPoint(x: 7 / 8 * widthRect, y: heightRect - CGFloat(2 * cornelBottom)))
        context?.addQuadCurve(to: CGPoint(x: 0.5 * widthRect , y: heightRect),
                              control: CGPoint(x: 5 / 8 * widthRect, y: heightRect - CGFloat(2 * cornelBottom)))
        context?.addQuadCurve(to: CGPoint(x: 0.25 * widthRect , y: heightRect),
                              control: CGPoint(x: 3 / 8 * widthRect, y: heightRect - CGFloat(2 * cornelBottom)))
        context?.addQuadCurve(to: CGPoint(x: 0 , y: heightRect),
                              control: CGPoint(x: 1 / 8 * widthRect, y: heightRect - CGFloat(2 * cornelBottom)))
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(5)
        context?.setFillColor(UIColor.blue.cgColor)
        context?.drawPath(using: .fillStroke)
        
        context?.addEllipse(in: CGRect(x: widthRect / 6 - 10, y: 50, width: 20, height: 20))
        context?.addEllipse(in: CGRect(x: 5 * widthRect / 6 - 10, y: 50, width: 20, height: 20))
        context?.move(to: CGPoint(x: 3 / 8 * widthRect, y: 0.5 * heightRect))
        context?.addQuadCurve(to: CGPoint(x: 5 / 8 * widthRect , y: 0.5 * heightRect),
                              control: CGPoint(x: 0.5 * widthRect, y: 0.5 * heightRect + 20 ))
        context?.addQuadCurve(to: CGPoint(x: 3 / 8 * widthRect , y: 0.5 * heightRect),
                              control: CGPoint(x: 0.5 * widthRect, y: 0.5 * heightRect + 2 * heightMouth ))
        
        context?.setStrokeColor(UIColor.red.cgColor)
        context?.setLineWidth(5)
        context?.setFillColor(UIColor.yellow.cgColor)
        context?.drawPath(using: .fillStroke)
    }
    
    
    
//    override func draw(_ rect: CGRect) {
//        let widthRect = rect.width
//        let heightRect = rect.height
//        let context = UIGraphicsGetCurrentContext()
//        let startPoint = CGPoint(x: 0, y: heightRect)
//
//        context?.move(to: startPoint)
//        context?.addLine(to: CGPoint(x: 0, y: 0))
//        context?.addLine(to: CGPoint(x: widthRect / 4, y: 0))
//        context?.addQuadCurve(to: CGPoint(x: 3 * widthRect / 4 , y: 0),
//                              control: CGPoint(x: widthRect / 2, y: heightRect / 2.3))
//        context?.addLine(to: CGPoint(x: widthRect, y: 0))
//        context?.addLine(to: CGPoint(x: widthRect, y: heightRect))
//        context?.addLine(to: startPoint)
//        context?.setFillColor(UIColor.blue.cgColor)
//
//        context?.setStrokeColor(UIColor.red.cgColor)
//        context?.setLineWidth(10)
//
//        context?.drawPath(using: .fill)
//    }
   
   ///True Linewidth
//    override func draw(_ rect: CGRect) {
//        let cornelRadius: CGFloat = 150
//
//        let widthRect = rect.width
//        let heightRect = rect.height
//        let lineWidth: CGFloat = 20
//        let context = UIGraphicsGetCurrentContext()
//        let move = lineWidth / 2
//
//        let startPoint = CGPoint(x: move, y: heightRect - move)
//        context?.setStrokeColor(UIColor.red.cgColor)
//        context?.setLineWidth(lineWidth)
//
//        context?.move(to: startPoint)
//        context?.addLine(to: CGPoint(x: move, y: cornelRadius))
//        context?.addQuadCurve(to: CGPoint(x: cornelRadius + move, y: move),
//                              control: CGPoint(x: move, y: 0))
//        context?.addLine(to: CGPoint(x: widthRect - cornelRadius - move, y: move))
//        context?.addQuadCurve(to: CGPoint(x: widthRect - lineWidth / 2, y: cornelRadius),
//                              control: CGPoint(x: widthRect - lineWidth / 2, y: move))
//        context?.addLine(to: CGPoint(x: widthRect - move, y: heightRect - move))
//        context?.addLine(to: CGPoint(x: 0, y: heightRect - move))
//        context?.setFillColor(UIColor.red.cgColor)
//
//        context?.move(to: CGPoint(x: 0, y: rect.height / 2))
//        context?.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
//        context?.drawPath(using: .stroke)
//    }
    
    
    ///Wrong LineWidth
//    override func draw(_ rect: CGRect) {
//        let cornelRadius: CGFloat = 150
//
//        let widthRect = rect.width
//        let heightRect = rect.height
//        let lineWidth: CGFloat = 20
//        let context = UIGraphicsGetCurrentContext()
//        let startPoint = CGPoint(x: 0, y: heightRect)
//        context?.setStrokeColor(UIColor.red.cgColor)
//        context?.setLineWidth(lineWidth)
//
//        context?.move(to: startPoint)
//        context?.addLine(to: CGPoint(x: 0, y: cornelRadius))
//        context?.addQuadCurve(to: CGPoint(x: cornelRadius, y: 0),
//                              control: CGPoint(x: 0, y: 0))
//        context?.addLine(to: CGPoint(x: widthRect - cornelRadius, y: 0))
//        context?.addQuadCurve(to: CGPoint(x: widthRect, y: cornelRadius),
//                              control: CGPoint(x: widthRect, y: 0))
//        context?.addLine(to: CGPoint(x: widthRect, y: heightRect))
//        context?.addLine(to: startPoint)
//        context?.setFillColor(UIColor.red.cgColor)
//
//        context?.move(to: CGPoint(x: 0, y: rect.height / 2))
//        context?.addLine(to: CGPoint(x: rect.width, y: rect.height / 2))
//        context?.drawPath(using: .stroke)
//    }
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate


//MARK: -
