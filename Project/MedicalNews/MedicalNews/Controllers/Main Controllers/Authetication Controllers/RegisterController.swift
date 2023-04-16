//
//  RegisterController.swift
//  MedicalNews
//
//  Created by Long Bảo on 06/03/2023.
//

import Foundation
import UIKit

class RegisterController: UIViewController {
    //MARK: - Properties    
    private let headerImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "BG"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 32 / 2
        button.setImage(UIImage(named: "back_arrow"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 0.3)
        return button
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 14)
        label.text = "EN / VI"
        label.widthAnchor.constraint(equalToConstant: 69).isActive = true
        label.heightAnchor.constraint(equalToConstant: 28).isActive = true
        label.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 0.3)
        label.textAlignment = .center
        label.layer.cornerRadius = 15
        label.clipsToBounds = true
        label.textColor = UIColor.white
        return label
    }()
    
    private lazy var codeNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "+84"
        label.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        label.textColor = UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var dividerView: UIView = {
        let view = UIView()
        view.layer.borderWidth  = 1
        view.layer.cornerRadius = 1
        view.backgroundColor = UIColor(red: 0.933, green: 0.937, blue: 0.957, alpha: 1)
        view.heightAnchor.constraint(equalToConstant: 32).isActive = true
        view.widthAnchor.constraint(equalToConstant: 1).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var inputPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "NunitoSans-SemiBold", size: 17)
        textField.placeholder = "Nhập số điện thoại"
        textField.textColor = UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1)
        textField.addTarget(self, action: #selector(handleDidBeginChangeTextField), for: .editingChanged)
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()
    
    private lazy var containerInputView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 56 / 2
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        view.addSubview(codeNumberLabel)
        view.addSubview(dividerView)
        view.addSubview(inputPhoneTextField)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        codeNumberLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        codeNumberLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        codeNumberLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 751), for: .horizontal)
        
        dividerView.leftAnchor.constraint(equalTo: codeNumberLabel.rightAnchor, constant: 16).isActive = true
        dividerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 12).isActive = true
        dividerView.setContentHuggingPriority(UILayoutPriority(rawValue: 752), for: .horizontal)
        
        inputPhoneTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 16).isActive = true
        inputPhoneTextField.leftAnchor.constraint(equalTo: dividerView.rightAnchor, constant: 16).isActive = true
        inputPhoneTextField.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22).isActive = true
        return view
    }()
    
    private let continuteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 48 / 2
        let attributedButton = NSMutableAttributedString(string: "Tiếp tục", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleContinueButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)
        button.alpha = 0.3
        button.isEnabled = false
        return button
    }()
    
    private lazy var hotlineImage: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Shape"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private lazy var hotlineLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        let textAttributed = NSMutableAttributedString(string: "Hotline", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Regular", size: 15) ?? UIFont.boldSystemFont(ofSize: 15)])
        textAttributed.append(NSAttributedString(string: " 1900 6036 893", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15), NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)]))
        label.attributedText = textAttributed
        return label
    }()
    
    private lazy var containerHotlineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hotlineImage)
        view.addSubview(hotlineLabel)
        view.layer.cornerRadius = 48 / 2
        
       
        let stack = UIStackView(arrangedSubviews: [hotlineImage, hotlineLabel])
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.spacing = 14
        stack.axis = .horizontal
        stack.alignment = .center
        view.backgroundColor = UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 0.1)
        return view
    }()
    
    //MARK: - View LifeCycle    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(headerImageView)
        headerImageView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        headerImageView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        headerImageView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        headerImageView.heightAnchor.constraint(equalTo: headerImageView.widthAnchor, multiplier: 188 / 375).isActive = true
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        view.addSubview(languageLabel)
        languageLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        languageLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        
        view.addSubview(containerInputView)
        containerInputView.topAnchor.constraint(equalTo: headerImageView.bottomAnchor, constant: 56).isActive = true
        containerInputView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        containerInputView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23).isActive = true
        containerInputView.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        view.addSubview(continuteButton)
        continuteButton.topAnchor.constraint(equalTo: containerInputView.bottomAnchor, constant: 20).isActive = true
        continuteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23).isActive = true
        continuteButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        continuteButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        view.addSubview(containerHotlineView)
        containerHotlineView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        containerHotlineView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 25).isActive = true
        containerHotlineView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -23).isActive = true
        containerHotlineView.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    private func enableView() {
        self.continuteButton.isEnabled = true
        self.continuteButton.alpha = 1
    }
    
    private func disableView() {
        self.continuteButton.isEnabled = false
        self.continuteButton.alpha = 0.3
    }
        
    //MARK: - Selectors
    @objc func handleBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func handleContinueButtonTapped() {
        guard let phoneNumber = inputPhoneTextField.text else {return}
        self.navigationController?.pushViewController(LoginController(phoneNumber: phoneNumber), animated: true)
    }
    
    @objc func handleDidBeginChangeTextField() {
        guard let text = inputPhoneTextField.text else {return}
        if text.count == 9 && text.first != Character("0") || text.count == 10 && text.first == Character("0") {
            self.enableView()
        } else {
            self.disableView()
        }
    }
    
    
}
