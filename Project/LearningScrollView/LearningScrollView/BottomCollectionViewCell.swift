//
//  BottomCollectionViewCell.swift
//  LearningScrollView
//
//  Created by Long Bảo on 09/05/2023.
//

import UIKit

class BottomCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "BottomCollectionViewCell"
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Wibu chúa"
        label.textColor = .white
        label.backgroundColor = .red
        return label
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
        addSubview(titleLabel)
        backgroundColor = .systemCyan
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate




