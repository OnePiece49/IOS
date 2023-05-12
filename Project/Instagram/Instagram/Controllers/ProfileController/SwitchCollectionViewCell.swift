//
//  SwitchCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 06/05/2023.
//

import Foundation

import UIKit

class SwitchCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "SwitchCollectionViewCell"
    
    private lazy var headerButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "Tags Icon"), for: .normal)
        button.imageView?.contentMode = .scaleToFill
        button.contentMode = .scaleToFill
        button.tintColor = .blue
        button.isUserInteractionEnabled = false
        return button
    }()
    
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
        addSubview(headerButton)
        NSLayoutConstraint.activate([
            headerButton.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        headerButton.setDimensions(width: 30, height: 35)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

