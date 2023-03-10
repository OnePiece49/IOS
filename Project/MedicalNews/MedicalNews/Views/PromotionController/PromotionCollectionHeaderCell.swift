//
//  PromotionCollectionHeaderCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 09/03/2023.
//

import Foundation
import UIKit

class PromotionCollectionHeaderCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "PromotionCollectionHeaderCell"
    var option: PromotionOption? {
        didSet {updateView()}
    }
    
     lazy var categoryLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
         label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        label.numberOfLines = 1
         label.text = "Danh mục"
        label.textColor = UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)
        return label
    }()
    
     lazy var promotionLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
         label.heightAnchor.constraint(equalToConstant: 24).isActive = true
        label.font = UIFont(name: "NunitoSans-SemiBold", size: 14)
         label.text = "Khuyến mãi"
        return label
    }()
    
    private lazy var expandButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 16).isActive = true
        button.setImage(UIImage(named: "Line"), for: .normal)
        button.addTarget(self, action: #selector(handleExpandButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor  = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgb: 0xEEEFF4).cgColor

        addSubview(categoryLabel)
        categoryLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        categoryLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        addSubview(promotionLabel)
        promotionLabel.topAnchor.constraint(equalTo: categoryLabel.bottomAnchor).isActive = true
        promotionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        addSubview(expandButton)
        expandButton.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        expandButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
    }
    
    
    func updateView() {
        self.promotionLabel.text = option?.topTitle
        self.categoryLabel.text = option?.bottomTitle
    }
    
    //MARK: - Selectors
    @objc func handleContinueButtonTapped() {
        
    }
    
    
    @objc func handleExpandButtonTapped() {
        
    }
}


