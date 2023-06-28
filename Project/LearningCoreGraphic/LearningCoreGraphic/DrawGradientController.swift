//
//  DrawGradient.swift
//  LearningCoreGraphic
//
//  Created by Tiến Việt Trịnh on 28/06/2023.
//

import UIKit


class DrawGradientController: UIViewController {
    //MARK: - Properties
    let draw = DrawGradient(frame: CGRect(x: 50, y: 250, width: 300, height: 400))
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(draw)
        draw.backgroundColor = .white
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
