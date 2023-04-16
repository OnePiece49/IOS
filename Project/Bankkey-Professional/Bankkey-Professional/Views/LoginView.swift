//
//  LoginView.swift
//  Bankkey-Professional
//
//  Created by Long Bảo on 21/03/2023.
//

import Foundation
import UIKit

class LoginView: UIView {
    
    //MARK: - Properties
    lazy var usernameTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Username"
        tf.text = "Vietdz"
        return tf
    }()
    
    private lazy var divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.text = "123456"
        tf.isSecureTextEntry = true
       // tf.isEnabled = true
        return tf
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 5
        clipsToBounds = true
        let stack = UIStackView(arrangedSubviews: [usernameTextField, divider, passwordTextField])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.backgroundColor = .clear
        stack.spacing = 8
        addSubview(stack)

        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalToSystemSpacingBelow: topAnchor, multiplier: 1),
            stack.leftAnchor.constraint(equalToSystemSpacingAfter: leftAnchor, multiplier: 1),
            rightAnchor.constraint(equalToSystemSpacingAfter: stack.rightAnchor	, multiplier: 1),
            bottomAnchor.constraint(equalToSystemSpacingBelow: stack.bottomAnchor, multiplier: 1)
            //bottomAnchor.
        ])
        
        divider.backgroundColor = .secondarySystemFill
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate


