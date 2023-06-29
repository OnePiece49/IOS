//
//  LayerController.swift
//  LearningCoreGraphic
//
//  Created by Tiến Việt Trịnh on 28/06/2023.
//

import UIKit



class LayerController: UIViewController {
    //MARK: - Properties
    let redView = UIView(frame: .init(x: 100, y: 300, width: 300, height: 300))
    let scrollLayer = CAScrollLayer()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        addTextLayer()
    }
    
    func addTextLayer (){
        let textLayer = CATextLayer()
        textLayer.string = "Hellooooooooo \n Siuuuuu \n 1231321"
        textLayer.foregroundColor = UIColor.white.cgColor
        textLayer.alignmentMode = .left
        textLayer.fontSize = 17
        textLayer.truncationMode = .none
        textLayer.backgroundColor = UIColor.red.cgColor
        textLayer.frame = CGRect(origin: CGPoint.zero, size: .init(width: 100, height: 60))
        textLayer.contentsScale = UIScreen.main.scale
        redView.layer.addSublayer(textLayer)
    }
    
    //MARK: - Helpsers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(redView)
        let imageLayer = CALayer()
        imageLayer.frame = redView.bounds
        imageLayer.contents = UIImage(named: "bp")?.cgImage
        imageLayer.contentsGravity = .resizeAspectFill
        
        imageLayer.isGeometryFlipped = true
        print("DEBUG: \(imageLayer.contentsAreFlipped())")
        
        redView.layer.addSublayer(imageLayer)
        
        redView.layer.borderColor = UIColor.blue.cgColor
        redView.layer.backgroundColor = UIColor.red.cgColor
        
    }
    
    //MARK: - Selectors
    @objc func handelScrollLayerMove(panGeture: UIPanGestureRecognizer) {
        let newPoint = panGeture.translation(in: redView)
        scrollLayer.scroll(to: newPoint)
//        print("DEBUG: \(scrollLayer.con)")
    }
}
//MARK: - delegate

