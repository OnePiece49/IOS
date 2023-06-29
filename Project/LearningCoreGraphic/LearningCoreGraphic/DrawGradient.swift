//
//  DrawGradient.swift
//  LearningCoreGraphic
//
//  Created by Tiến Việt Trịnh on 28/06/2023.
//

import UIKit

private enum Constants {
    static let cornerRadiusSize = CGSize(width: 20, height: 0.0)
  static let margin: CGFloat = 20
  static let topBorder: CGFloat = 60
  static let bottomBorder: CGFloat = 50
  static let colorAlpha: CGFloat = 0.3
  static let circleDiameter: CGFloat = 5.0
}

class DrawGradient: UIView {
    override func draw(_ rect: CGRect) {
        let cornelpath = UIBezierPath(
          roundedRect: rect,
          byRoundingCorners: .allCorners,
          cornerRadii: Constants.cornerRadiusSize
        )
        UIColor.white.setFill()
        UIColor.white.setStroke()
        cornelpath.stroke()
        cornelpath.addClip()

        guard let context = UIGraphicsGetCurrentContext() else {return}
        let startColor: CGColor = UIColor(red: 250 / 255, green: 233 / 255, blue: 222 / 255, alpha: 1).cgColor
        let endColor: CGColor = UIColor(red: 252 / 255, green: 79 / 255, blue: 8 / 255, alpha: 1).cgColor
        guard let gradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: [startColor, endColor] as CFArray,
                                  locations: [0.0, 1.0])
        else {return}
        
        context.drawLinearGradient(gradient,
                                   start: CGPoint.zero,
                                   end: CGPoint(x: 0, y: rect.height),
                                   options: .drawsBeforeStartLocation)
        
        let path = UIBezierPath()
        let points = [CGPoint(x: 10, y: 100),
                      CGPoint(x: 60, y: 150),
                      CGPoint(x: 110, y: 60),
                      CGPoint(x: 140, y: 50),
                      CGPoint(x: 180, y: 30),
                      CGPoint(x: 220, y: 130)]
        points.forEach { point in
            if points.first == point {
                path.move(to: point)
                return
            }
            
            path.addLine(to: point)
        }
        
        UIColor.white.setStroke()
        UIColor.white.setFill()

        path.lineWidth = 3
        path.stroke()
        context.saveGState()
        
        guard let clippingPath = path.copy() as? UIBezierPath else {return}
        clippingPath.addLine(to: CGPoint(x: clippingPath.currentPoint.x, y: rect.height))
        clippingPath.addLine(to: CGPoint(x: points[0].x, y: rect.height))
        clippingPath.close()
        clippingPath.addClip()
        
        let startColorGraph: CGColor = UIColor.red.cgColor
        let endColorGraph: CGColor = UIColor.green.cgColor
        guard let gradientGraph = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(),
                                  colors: [startColorGraph, endColorGraph] as CFArray,
                                             locations: [0.0, 1.0]) else {return}
        context.drawLinearGradient(gradientGraph,
                                   start: CGPoint(x: 0, y: 0),
                                   end: CGPoint(x: 220, y: rect.height),
                                   options: [])
        
        context.restoreGState()

        points.forEach { point in
            let path = UIBezierPath(arcCenter: point,
                                    radius: 4,
                                    startAngle: 0,
                                    endAngle: .pi * 2,
                                    clockwise: true)
            path.fill()
            path.stroke()
        }
        
    }
}
