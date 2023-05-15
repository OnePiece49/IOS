//
//  InstagramHeaderView.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

import UIKit

class BadgeValueLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setDimensions(width: 18, height: 18)
        layer.cornerRadius = 18 / 2
        layer.masksToBounds = true
        backgroundColor = .red
        textColor = .white
        text = "1"
        textAlignment = .center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

class InstagramHeaderView: UIView {
    //MARK: - Properties
    
    lazy var messageBadgeValueLabel = BadgeValueLabel(frame: .zero)
    lazy var likeBadgeValueLabel = BadgeValueLabel(frame: .zero)
    
    private lazy var instagramLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Instagram"
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    private lazy var likeButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "like"), for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private lazy var messageButton: UIButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "message"), for: .normal)
        button.tintColor = .black

        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [likeButton, messageButton])
        stackView.axis = .horizontal
        stackView.spacing = 21
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
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
        //backgroundColor = .black
        addSubview(instagramLabel)
        addSubview(buttonStackView)
        addSubview(likeBadgeValueLabel)
        addSubview(messageBadgeValueLabel)
        
        
        NSLayoutConstraint.activate([
            instagramLabel.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 1),
            instagramLabel.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0),
        ])
        
        NSLayoutConstraint.activate([
            buttonStackView.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 0),
            buttonStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -30)
        ])
        
        NSLayoutConstraint.activate([
            messageBadgeValueLabel.bottomAnchor.constraint(equalTo: messageButton.topAnchor, constant: 8),
            messageBadgeValueLabel.leftAnchor.constraint(equalTo: messageButton.rightAnchor, constant: -8),
        ])
        
        NSLayoutConstraint.activate([
            likeBadgeValueLabel.bottomAnchor.constraint(equalTo: likeButton.topAnchor, constant: 10),
            likeBadgeValueLabel.leftAnchor.constraint(equalTo: likeButton.rightAnchor, constant: -10),
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
