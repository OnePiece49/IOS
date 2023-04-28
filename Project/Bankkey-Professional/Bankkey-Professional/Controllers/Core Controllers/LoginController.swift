//
//  ViewController.swift
//  Bankkey-Professional
//
//  Created by Long Bảo on 21/03/2023.
//

import UIKit

class LoginController: UIViewController {
    
    //MARK: - Propertier
    let login = LoginView()
    
    private var username: String? {
        return login.usernameTextField.text
    }
    
    private var password: String? {
        return login.passwordTextField.text
    }
    
    private lazy var mainTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Bankey"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Your premium source for all things banking!"
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var errorMessageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .systemRed
        label.text = "Error Failure"
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.configuration = .filled()
        button.configuration?.imagePadding = 8 //Xét khoảng cách cho Button và Text
        button.setTitle("Sign In", for: .normal)
        button.addTarget(self, action: #selector(signInButtonTapped), for: .primaryActionTriggered)
        return button
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(login)
        view.addSubview(errorMessageLabel)
        view.addSubview(loginButton)
        view.addSubview(mainTitleLabel)
        view.addSubview(subTitleLabel)
        
        //login
        login.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            login.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            login.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10),
            login.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10),
            //login.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        //loginButton
        NSLayoutConstraint.activate([
            loginButton.topAnchor.constraint(equalToSystemSpacingBelow: login.bottomAnchor, multiplier: 1.5),
            loginButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            loginButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8)
        ])
        
        //ErrorMessage
        NSLayoutConstraint.activate([
            errorMessageLabel.topAnchor.constraint(equalToSystemSpacingBelow: loginButton.bottomAnchor, multiplier: 1.5),
            errorMessageLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            errorMessageLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
        ])
        
        //SubTitleLabel
        NSLayoutConstraint.activate([
            subTitleLabel.bottomAnchor.constraint(equalTo: login.topAnchor, constant: -16),
            subTitleLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            subTitleLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
            
        ])
        //MaintitleLabel
        NSLayoutConstraint.activate([
            mainTitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            mainTitleLabel.bottomAnchor.constraint(equalTo: subTitleLabel.topAnchor, constant: -20)
        ])
    }

    //MARK: - Selectors
    @objc func signInButtonTapped() {
        errorMessageLabel.isHidden = true
        handleSignIn()
    }
    
    private func handleSignIn() {
        guard let username = username, let password = password else {
            return
        }
        
        if username.isEmpty || password.isEmpty {
            self.updateErrorMessageLabel(withMessage: "Username / Password cannot be blank")
            return
        }
        
        if username == "Vietdz" && password == "123456" {
            loginButton.configuration?.showsActivityIndicator = true
        
            self.navigationController?.pushViewController(OnboardContainerViewController(), animated: true)
            //self.navigationController?.pushViewController(LearningScrollViewController(), animated: true)
        } else {
            self.updateErrorMessageLabel(withMessage: "Incorrect username / password")
        }

    }
    
    private func updateErrorMessageLabel(withMessage message: String) {
        self.errorMessageLabel.isHidden = false
        self.errorMessageLabel.text = message
    }
    
}
//MARK: - delegate
