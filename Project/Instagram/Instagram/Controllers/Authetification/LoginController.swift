//
//  LoginController.swift
//  Instagram
//
//  Created by Long Bảo on 03/05/2023.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore

class LoginController: UIViewController {
    //MARK: - Properties
    private let db = Firestore.firestore()
    
    private let titleImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "title"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private lazy var loginLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "LOGIN"
        label.textAlignment = .center
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.layer.cornerRadius = 4
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.clipsToBounds = true
        label.clipsToBounds = true
        label.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleLoginLabelTapped)))
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedString = NSMutableAttributedString(string: "Dont't have an account ? ", attributes: [.foregroundColor: UIColor.blue, .font : UIFont.systemFont(ofSize: 18, weight: .medium)])
        
        attributedString.append(NSAttributedString(string: "Sign Up", attributes: [.foregroundColor : UIColor.blue, .font : UIFont.systemFont(ofSize: 18, weight: .medium)]))
        button.setAttributedTitle(attributedString, for: .normal)
        button.addTarget(self, action: #selector(handleDontHaveAccountButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = .red
        label.numberOfLines = 0
        label.isHidden = true
        label.textColor = .white
        label.textAlignment = .center
        label.layer.cornerRadius = 5.1
        label.clipsToBounds = true
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.borderWidth = 0.6
        view.layer.borderColor = UIColor.blue.cgColor
        return view
    }()
    
    private let userTextField = Utilites.createTextField(with: "Phone Number, Username or Email", with: "viet@gmail.com")
    private let passwordTextField = Utilites.createTextField(with: "Password", with: "123456")
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        let layer0 = CAGradientLayer()
        layer0.colors = [
          UIColor(red: 0.639, green: 0.212, blue: 0.741, alpha: 1).cgColor,
          UIColor(red: 1, green: 0.22, blue: 0.49, alpha: 1).cgColor,
          UIColor(red: 1, green: 0.365, blue: 0.204, alpha: 1).cgColor,
          UIColor(red: 1, green: 0.667, blue: 0.106, alpha: 1).cgColor
        ]
        layer0.locations = [0, 0.31, 0.68, 1]
        layer0.frame = view.bounds
        print("DEBUG: \(loginLabel.frame)")
        view.layer.insertSublayer(layer0, at: 0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        view.addSubview(titleImageView)
        view.addSubview(userTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginLabel)
        view.addSubview(divider)
        view.addSubview(dontHaveAccountButton)
        view.addSubview(errorLabel)
        
        NSLayoutConstraint.activate([
            titleImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150),
            titleImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: titleImageView.bottomAnchor, constant: 50),
            userTextField.centerXAnchor.constraint(equalTo: titleImageView.centerXAnchor),
            userTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            userTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(equalTo: userTextField.bottomAnchor, constant: 12),
            passwordTextField.centerXAnchor.constraint(equalTo: titleImageView.centerXAnchor),
            passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            passwordTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
        
        NSLayoutConstraint.activate([
            loginLabel.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 16),
            loginLabel.centerXAnchor.constraint(equalTo: titleImageView.centerXAnchor),
            loginLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            loginLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
            loginLabel.heightAnchor.constraint(equalTo: passwordTextField.heightAnchor, constant: -9),
        ])
        
        NSLayoutConstraint.activate([
            divider.bottomAnchor.constraint(equalTo: dontHaveAccountButton.topAnchor, constant: -8),
            divider.leftAnchor.constraint(equalTo: view.leftAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1),
            divider.widthAnchor.constraint(equalTo: view.widthAnchor),
        ])
        
        NSLayoutConstraint.activate([
            dontHaveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15),
            dontHaveAccountButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        
        NSLayoutConstraint.activate([
            errorLabel.topAnchor.constraint(equalTo: loginLabel.bottomAnchor, constant: 10),
            errorLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 30),
            errorLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -30),
        ])
   
    }
    
    func activeErrorLabel(with text: String) {
        self.errorLabel.text = text
        self.errorLabel.isHidden = false
    }
    
    //MARK: - Selectors
    @objc func handleDontHaveAccountButtonTapped() {
        navigationController?.pushViewController(RegisterController(), animated: true)
    }
    
    @objc func handleLoginLabelTapped() {
        guard let email = userTextField.text,
              let password = passwordTextField.text else {return}
        
        if email == "" || password == "" {
            self.activeErrorLabel(with: "Username(email) and password must not be empty")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { auth, error in
            if let error = error {
                self.activeErrorLabel(with: error.localizedDescription)
                return
            }
            
            self.errorLabel.isHidden = true
            let mainTBVC = MainTabBarController()
            mainTBVC.modalPresentationStyle = .fullScreen
            self.present(mainTBVC, animated: true, completion: .none)
        }
    }
    
}
//MARK: - delegate
