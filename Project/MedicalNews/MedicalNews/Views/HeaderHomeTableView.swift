//
//  HeaderHomeTableView.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HeaderHomeTableView: UIView {
    //MARK: - Properties
    var option: TitleSection? {
        didSet {
            configure()
        }
    }
    
    private lazy var mainInfoLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 17)
        label.textColor = UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var getAllNewsButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedButton = NSMutableAttributedString(string: "Xem tất cả", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-SemiBold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleGetAllNewsButtonTapped), for: .touchUpInside)
        return button
        
    }()
    
    private lazy var getAllNewsImageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 6).isActive = true
        button.heightAnchor.constraint(equalToConstant: 12).isActive = true
        button.setImage(UIImage(named: "Vector"), for: .normal)
        button.addTarget(self, action: #selector(handleGetAllNewsButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var getAllNewsStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [getAllNewsButton, getAllNewsImageButton])
        stack.spacing = 5
        stack.axis = .horizontal
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
        addSubview(mainInfoLabel)
        addSubview(getAllNewsStack)
        mainInfoLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        mainInfoLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        getAllNewsStack.topAnchor.constraint(equalTo: topAnchor, constant: 21).isActive = true
        getAllNewsStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -21).isActive = true
    }
    
    func configure() {
        guard let option = option else {
            return
        }

        mainInfoLabel.text = option.description
    }
    
    
    //MARK: - Selectors
    @objc func handleGetAllNewsButtonTapped() {
        
    }
    

    
}
