//
//  HeaderNewsController.swift
//  MedicalNews
//
//  Created by Long Bảo on 08/03/2023.
//

import Foundation
import UIKit

protocol NewsHeaderControllerDelegate: AnyObject {
    func didBackButtonTapped()
}

class NewsHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: NewsHeaderControllerDelegate?
    let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Rectangle 4767")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 32 / 2
        button.setImage(UIImage(named: "chevron-left"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 0.3)
        button.backgroundColor = UIColor(rgb: 0xFFFFFF)
        return button
    }()
    
    private lazy var shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 32 / 2
        button.setImage(UIImage(named: "Group"), for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(rgb: 0xEEEFF4).cgColor
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(rgb: 0xFFFFFF)
        return button
    }()
    
     lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 20)
        label.textColor =  UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1)
        label.textAlignment = .left
        label.text = "Tin tức"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, titleLabel, shareButton])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        shareButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return stack
    }()
    
    lazy var mainNewsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 20)
        label.textColor =  UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1)
        label.textAlignment = .left
        label.text = "Jio Health khởi động chương trình Doctor Tour 2021"
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        label.textColor =  UIColor(red: 0.492, green: 0.516, blue: 0.596, alpha: 1)
        label.textAlignment = .center
        label.text = "23 tháng 6 2021"
        return label
    }()
    
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(headerImageView)
        addSubview(titleStack)
        titleStack.topAnchor.constraint(equalTo: topAnchor, constant: 44).isActive = true
        titleStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        titleStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        headerImageView.topAnchor.constraint(equalTo: titleStack.bottomAnchor).isActive = true
        headerImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerImageView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor, multiplier: 200 / 375).isActive = true
        
        let stack = UIStackView(arrangedSubviews: [mainNewsTitleLabel, dateLabel])
        addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 16).isActive = true
        stack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        stack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        stack.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    @objc func handleBackButtonTapped() {
        delegate?.didBackButtonTapped()
    }
}
