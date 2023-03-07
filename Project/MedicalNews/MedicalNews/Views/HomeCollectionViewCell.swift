//
//  HomeCollectionViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "HomeCollectionViewCell"
    private lazy var titleImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Image"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private lazy var mainTitleLabel: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedButton = NSMutableAttributedString(string: "Jio Health khởi động chương trình Doctor Tour 2021", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 17)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleContinueButtonTapped), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let textAttributed = NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        textAttributed.append(NSAttributedString(string: " • ", attributes: [ NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.851, green: 0.859, blue: 0.882, alpha: 1)]))
        textAttributed.append(NSAttributedString(string: "28/6/2021 ", attributes: [ NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.851, green: 0.859, blue: 0.882, alpha: 1), NSAttributedString.Key.font : UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 13)]))
        label.attributedText = textAttributed
        return label
    }()
    
    private lazy var stackTitle: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
        stack.axis = .vertical
        stack.spacing = 4
        stack.translatesAutoresizingMaskIntoConstraints = false
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
        addSubview(titleImage)
        titleImage.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleImage.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        titleImage.heightAnchor.constraint(equalToConstant: 134).isActive = true
        titleImage.widthAnchor.constraint(equalTo: titleImage.heightAnchor, multiplier: 258 / 134).isActive = true
        
        addSubview(stackTitle)
        stackTitle.topAnchor.constraint(equalTo: titleImage.bottomAnchor, constant: 12).isActive = true
        stackTitle.leftAnchor.constraint(equalTo: titleImage.leftAnchor, constant: 12).isActive = true
        stackTitle.rightAnchor.constraint(equalTo: titleImage.rightAnchor, constant: -12).isActive = true
        stackTitle.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
    
    //MARK: - Selectors
    @objc func handleContinueButtonTapped() {
        
    }
}
