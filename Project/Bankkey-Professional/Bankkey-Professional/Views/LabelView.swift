//
//  LabelView.swift
//  Bankkey-Professional
//
//  Created by Long Bảo on 21/03/2023.
//

import Foundation

import UIKit

class LabelView: UILabel {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: CGRect(x: 15, y: 105, width: 50, height: 30))
        //super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 200, height: 100)
    }
    
    //MARK: - Helpers
    func configureUI() {
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
