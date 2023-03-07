//
//  HeaderHomeView.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HeaderHomeView: UIView {
    //MARK: - Properties
    private let headerImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "background-home")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private var avatarImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "Avatar")
        iv.contentMode = .scaleToFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 15)
        label.textColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.text = "Quỳnh Ken"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var isActiveLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        label.textColor =  UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        label.textAlignment = .center
        label.text = "Đang trực tuyến"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var isActiveView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalTo: view.heightAnchor).isActive = true
        view.heightAnchor.constraint(equalToConstant: 8).isActive = true
        view.layer.cornerRadius = 8 / 2
        view.backgroundColor = UIColor(red: 0.067, green: 1, blue: 0.726, alpha: 1)
        return view
    }()
    
    private lazy var userActiveStack: UIStackView = {
        let activeStack = UIStackView(arrangedSubviews: [isActiveView, isActiveLabel])
        activeStack.axis = .horizontal
        activeStack.spacing = 6
        activeStack.alignment = .center
        
        let stack = UIStackView(arrangedSubviews: [userNameLabel, activeStack])
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .top
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        headerImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        headerImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        headerImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        headerImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        addSubview(avatarImage)
        avatarImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        avatarImage.topAnchor.constraint(equalTo: topAnchor, constant: 60).isActive = true
        avatarImage.widthAnchor.constraint(equalTo: avatarImage.heightAnchor).isActive = true
        avatarImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        
        addSubview(userActiveStack)
        userActiveStack.topAnchor.constraint(equalTo: topAnchor, constant: 61).isActive = true
        userActiveStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
    }
    
    //MARK: -
}
