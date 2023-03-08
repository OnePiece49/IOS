//
//  HomeDoctorCollectionViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HomeDoctorCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "HomeDoctorCollectionViewCell"
     lazy var userNameImage: UIImageView = {
         let iv = UIImageView()
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.contentMode = .scaleToFill
         iv.layer.masksToBounds = true
         iv.layer.cornerRadius = 12
         return iv
    }()
    
    lazy var starImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Star"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 12).isActive = true
        return iv
   }()
    
     lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 13)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleContinueButtonTapped))
        label.addGestureRecognizer(tap)
        label.isUserInteractionEnabled = true
        label.numberOfLines = 0
        label.textColor = UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1)
        return label
    }()
    
     lazy var majorLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        return label
    }()
    
    lazy var reviewLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 0.278, green: 0.29, blue: 0.341, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 14)
        return label
    }()
    
    
    private lazy var reviewStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [starImage, reviewLabel])
        stack.spacing = 6
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    private lazy var infoUserStack: UIStackView = {
        let usernameMajorStack = UIStackView(arrangedSubviews: [userNameLabel, majorLabel])
        usernameMajorStack.axis = .vertical
        usernameMajorStack.spacing = 4
        usernameMajorStack.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView(arrangedSubviews: [usernameMajorStack, reviewStack])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    

    
    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        layer.cornerRadius = 16
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor  = UIColor.white
        layer.borderWidth = 1
        layer.borderColor = UIColor(rgb: 0xEEEFF4).cgColor
        addSubview(userNameImage)
        userNameImage.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        userNameImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userNameImage.heightAnchor.constraint(equalToConstant: 97).isActive = true
        userNameImage.widthAnchor.constraint(equalToConstant: 97).isActive = true
        
        addSubview(infoUserStack)
        majorLabel.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
        infoUserStack.topAnchor.constraint(equalTo: userNameImage.bottomAnchor, constant: 12).isActive = true
        infoUserStack.leftAnchor.constraint(equalTo: userNameImage.leftAnchor, constant: 12).isActive = true
        infoUserStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        infoUserStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
    }
    
    //MARK: - Selectors
    @objc func handleContinueButtonTapped() {
        
    }
    
}
