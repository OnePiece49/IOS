//
//  HomeCollectionViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit
import SDWebImage

class HomeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "HomeCollectionViewCell"

    lazy var titleImage: UIImageView = {
         let iv = UIImageView(image: UIImage(named: "Image"))
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.contentMode = .scaleToFill
         iv.layer.cornerRadius = 16
         iv.clipsToBounds = true
         iv.roundCorners(corners: [.topLeft], radius: 16)
        return iv
    }()
    
     lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleContinueButtonTapped))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        return label
    }()
    
     lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var stackTitle: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .top
        mainTitleLabel.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        return stack
    }()
    
    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor  = UIColor(rgb: 0xFFFFFF)
        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.3
        layer.cornerRadius = 16
        addSubview(titleImage)
        titleImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleImage.heightAnchor.constraint(equalToConstant: 134).isActive = true
        titleImage.widthAnchor.constraint(equalTo: titleImage.heightAnchor, multiplier: 258 / 134).isActive = true
        titleImage.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
        
        addSubview(stackTitle)
        subTitleLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 752), for: .vertical)
        subTitleLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 751), for: .vertical)
        stackTitle.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 6).isActive = true
        stackTitle.leftAnchor.constraint(equalTo: titleImage.leftAnchor, constant: 11).isActive = true
        stackTitle.rightAnchor.constraint(equalTo: titleImage.rightAnchor, constant: -12).isActive = true
        stackTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -11).isActive = true
    }
    
    //MARK: - Selectors
    @objc func handleContinueButtonTapped() {
        
    }
}
