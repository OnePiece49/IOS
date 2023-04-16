//
//  DoctorTableViewCel.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit
import SDWebImage

class DoctorCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = "DoctorCollectionViewCell"
    var viewModel: DoctorViewModel? {
        didSet {configure()}
    }
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
    
    override func layoutSubviews() {
        configureUI()
    }
    
    //MARK: - View LifeCycle    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 12
        layer.borderWidth = 1
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
        userNameImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 12.48).isActive = true
        userNameImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        userNameImage.widthAnchor.constraint(equalToConstant: 83.78).isActive = true
        
        addSubview(userNameLabel)
        userNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        userNameLabel.leftAnchor.constraint(equalTo: userNameImage.rightAnchor, constant: 15.34).isActive = true
        userNameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(majorLabel)
        majorLabel.topAnchor.constraint(equalTo: userNameLabel.bottomAnchor, constant: 6).isActive = true
        majorLabel.leftAnchor.constraint(equalTo: userNameImage.rightAnchor, constant: 15.34).isActive = true
        majorLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        addSubview(reviewStack)
        reviewStack.topAnchor.constraint(equalTo: majorLabel.bottomAnchor, constant: 6).isActive = true
        reviewStack.leftAnchor.constraint(equalTo: userNameImage.rightAnchor, constant: 15.34).isActive = true
        reviewStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        userNameLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        
    }
    
    //MARK: - Selectors
    @objc func handleContinueButtonTapped() {
        
    }
    
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }

        self.majorLabel.text = viewModel.majorDoctorString
        self.reviewLabel.attributedText = viewModel.reviewTextAttributed
        self.userNameImage.sd_setImage(with: viewModel.imageURL, completed: .none)
        self.userNameLabel.text = viewModel.userNameDoctorString
        self.userNameImage.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(named: "doctor"), options: .lowPriority, completed: .none)
        
    }
}
