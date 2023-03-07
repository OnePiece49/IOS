//
//  LoginController.swift
//  MedicalNews
//
//  Created by Long Bảo on 06/03/2023.
//

import Foundation
import UIKit

class LoginController: UIViewController {
    //MARK: - Properties
    private let phoneNumber: String!
    private var counter: Int = 0
    private var time: Int = 0
    private var lastNumberCharacter: [Int] = [0, 0, 0, 0, 0, 0, 0]
    
    private  var heightKeypad: CGFloat = 0
    private lazy var bottomAnchorContinuteButtonToView: NSLayoutConstraint = continuteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
    private lazy var bottomAnchorContinuteButtonToResendButton: NSLayoutConstraint = continuteButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -315)
    
    private let checkPhoneNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 18)
        label.text = "Xác minh số điện thoại"
        label.textColor = UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 32).isActive = true
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.layer.cornerRadius = 32 / 2
        button.setImage(UIImage(named: "chevron-left"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.backgroundColor = .white
        return button
    }()
    
    private lazy var infoLabel: UILabel = {
        let label = UILabel()
        guard let phoneNumber = self.phoneNumber else {return label}
        label.translatesAutoresizingMaskIntoConstraints = false
        let textAttributed = NSMutableAttributedString(string: "Vui lòng nhập mã gồm 6 chữ số đã được gửi đến bạn vào số điện thoại", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Regular", size: 15) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor:  UIColor(red: 0.212, green: 0.239, blue: 0.306, alpha: 1)])
        textAttributed.append(NSAttributedString(string: " +84 \(phoneNumber)", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor:  UIColor(red: 0.212, green: 0.239, blue: 0.306, alpha: 1)]))
        label.attributedText = textAttributed
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var input1TextField: InputTextField = {
        let textField = InputTextField()
        textField.delegateInput = self
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Inter-Medium", size: 20)
        textField.textColor = UIColor(red: 0.016, green: 0.047, blue: 0.133, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.widthAnchor.constraint(equalToConstant: 36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.keyboardType = .asciiCapableNumberPad
        textField.tag = 1
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(hanldeTextFieldDidBegin), for: .editingChanged)
        return textField
    }()
    
    private lazy var input2TextField: InputTextField = {
        let textField = InputTextField()
        textField.layer.cornerRadius = 8
        textField.delegateInput = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Inter-Medium", size: 20)
        textField.textColor = UIColor(red: 0.016, green: 0.047, blue: 0.133, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.widthAnchor.constraint(equalToConstant: 36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.keyboardType = .asciiCapableNumberPad
        textField.tag = 2
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(hanldeTextFieldDidBegin), for: .editingChanged)
        return textField
    }()
    
    private lazy var input3TextField: InputTextField = {
        let textField = InputTextField()
        textField.layer.cornerRadius = 8
        textField.delegateInput = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Inter-Medium", size: 20)
        textField.textColor = UIColor(red: 0.016, green: 0.047, blue: 0.133, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.widthAnchor.constraint(equalToConstant: 36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.keyboardType = .asciiCapableNumberPad
        textField.tag = 3
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(hanldeTextFieldDidBegin), for: .editingChanged)
        return textField
    }()
    
    private lazy var input4TextField: InputTextField = {
        let textField = InputTextField()
        textField.layer.cornerRadius = 8
        textField.delegateInput = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Inter-Medium", size: 20)
        textField.textColor = UIColor(red: 0.016, green: 0.047, blue: 0.133, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.widthAnchor.constraint(equalToConstant: 36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.keyboardType = .asciiCapableNumberPad
        textField.tag = 4
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(hanldeTextFieldDidBegin), for: .editingChanged)
        return textField
    }()
    
    private lazy var input5TextField: InputTextField = {
        let textField = InputTextField()
        textField.layer.cornerRadius = 8
        textField.delegateInput = self
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Inter-Medium", size: 20)
        textField.textColor = UIColor(red: 0.016, green: 0.047, blue: 0.133, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.widthAnchor.constraint(equalToConstant: 36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.keyboardType = .asciiCapableNumberPad
        textField.tag = 5
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(hanldeTextFieldDidBegin), for: .editingChanged)
        return textField
    }()
    
    private lazy var input6TextField: InputTextField = {
        let textField = InputTextField()
        textField.delegateInput = self
        textField.layer.cornerRadius = 8
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "Inter-Medium", size: 20)
        textField.textColor = UIColor(red: 0.016, green: 0.047, blue: 0.133, alpha: 1)
        textField.textAlignment = .center
        textField.backgroundColor = .white
        textField.widthAnchor.constraint(equalToConstant: 36).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 42).isActive = true
        textField.keyboardType = .asciiCapableNumberPad
        textField.tag = 6
        textField.layer.borderWidth = 1
        textField.addTarget(self, action: #selector(hanldeTextFieldDidBegin), for: .editingChanged)
        return textField
    }()
    
    private lazy var inputPhoneNumberStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [input1TextField, input2TextField, input3TextField, input4TextField, input5TextField, input6TextField])
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var wrongCodeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        label.text = "Nhập sai mã xác thực"
        label.textColor = UIColor(red: 0.988, green: 0.141, blue: 0.208, alpha: 1)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var resendMessageButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributedButton = NSMutableAttributedString(string: "Gửi lại mã sau 60s", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1).cgColor
        button.layer.cornerRadius = 32 / 2
        button.heightAnchor.constraint(equalToConstant: 32).isActive = true
        button.widthAnchor.constraint(equalToConstant: 180).isActive = true
        button.alpha = 0.3
        button.addTarget(self, action: #selector(handleResendButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var wrongCodeResendStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [wrongCodeLabel, resendMessageButton])
        stack.axis = .vertical
        stack.spacing = 39
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.alignment = .center
        return stack
    }()
    
    private let continuteButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 32 / 2
        let attributedButton = NSMutableAttributedString(string: "Tiếp tục", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleContinueButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)
        button.alpha = 0.3
        button.isEnabled = false
        button.layer.cornerRadius = 24
        return button
    }()
    
    //MARK: - View Lifecycle
    init(phoneNumber: String) {
        self.phoneNumber = phoneNumber
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        setNotificationCenter()
        setFirstBecomeResponder()
        disableMultipleInputTextField(from: 2, to: 6)
        enableInputTextField(index: 1)
        setTimerForResendButton()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor(red: 0.953, green: 0.961, blue: 0.984, alpha: 1)
        view.addSubview(checkPhoneNumberLabel)
        checkPhoneNumberLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        checkPhoneNumberLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 56).isActive = true
        
        view.addSubview(backButton)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        
        view.addSubview(infoLabel)
        infoLabel.topAnchor.constraint(equalTo: checkPhoneNumberLabel.bottomAnchor, constant: 32).isActive = true
        infoLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        infoLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        infoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        view.addSubview(inputPhoneNumberStack)
        inputPhoneNumberStack.topAnchor.constraint(equalTo: infoLabel.bottomAnchor, constant: 20).isActive = true
        inputPhoneNumberStack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 39).isActive = true
        inputPhoneNumberStack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -39).isActive = true
        
        view.addSubview(wrongCodeResendStack)
        wrongCodeResendStack.topAnchor.constraint(equalTo: inputPhoneNumberStack.bottomAnchor, constant: 16).isActive = true
        wrongCodeResendStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wrongCodeLabel.isHidden = true

        view.addSubview(continuteButton)
        continuteButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -24).isActive = true
        continuteButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 24).isActive = true
        continuteButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
        bottomAnchorContinuteButtonToView.isActive = true
    }
    
    private func setNotificationCenter() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    private func setTimerForResendButton() {
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(handleTimer), userInfo: nil, repeats: true)
    }
    
    @objc func handleTimer(timer: Timer) {
        self.counter += 1
        self.time = 60 - self.counter
        let attributedButton = NSMutableAttributedString(string: "Gửi lại mã sau \(self.time)s", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        self.resendMessageButton.setAttributedTitle(attributedButton, for: .normal)
        if self.counter == 60 {
            self.counter = -1
            timer.invalidate()
            enableResendButton()
        }
    }
    
    private func enableResendButton() {
        self.resendMessageButton.alpha = 1.0
        self.resendMessageButton.isEnabled = true
        let attributedButton = NSMutableAttributedString(string: "Gửi lại mã sau", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        self.resendMessageButton.setAttributedTitle(attributedButton, for: .normal)
    }
    
    private func setFirstBecomeResponder() {
        input1TextField.becomeFirstResponder()
    }
    
    private func enableContinuteButton() {
        continuteButton.alpha = 1
        continuteButton.isEnabled = true
    }
    
    private func disableContinuteButton() {
        continuteButton.alpha = 0.3
        continuteButton.isEnabled = false
    }
    
    private func enableInputTextField(index: Int) {
        if index == 1 {
            input1TextField.isUserInteractionEnabled = true
            input1TextField.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        }
        
        if index == 2 {
            input2TextField.isUserInteractionEnabled = true
            input2TextField.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        }
        
        if index == 3 {
            input3TextField.isUserInteractionEnabled = true
            input3TextField.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        }
        
        if index == 4 {
            input4TextField.isUserInteractionEnabled = true
            input4TextField.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        }
        
        if index == 5 {
            input5TextField.isUserInteractionEnabled = true
            input5TextField.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        }
        
        if index == 6 {
            input6TextField.isUserInteractionEnabled = true
            input6TextField.layer.borderColor = UIColor(rgb: 0x2C8667).cgColor
        }
    }
    
    private func disableInputTextField(index: Int) {
        if index == 1 {
            input1TextField.isUserInteractionEnabled = false
            input1TextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if index == 2 {
            input2TextField.isUserInteractionEnabled = false
            input2TextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if index == 3 {
            input3TextField.isUserInteractionEnabled = false
            input3TextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if index == 4 {
            input4TextField.isUserInteractionEnabled = false
            input4TextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if index == 5 {
            input5TextField.isUserInteractionEnabled = false
            input5TextField.layer.borderColor = UIColor.clear.cgColor
        }
        
        if index == 6 {
            input6TextField.isUserInteractionEnabled = false
            input6TextField.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    private func disableMultipleInputTextField(from: Int, to: Int) {
        for i in from...to {
            disableInputTextField(index: i)
        }
    }
    
    private func disableMultipleInputTextField(before index: Int) {
        for i in 1...index {
            disableInputTextField(index: i)
        }
    }
    
    
    //MARK: - Selectors
    @objc func handleBackButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func handleResendButtonTapped() {
        self.setTimerForResendButton()
        self.resendMessageButton.isEnabled = false
        self.resendMessageButton.alpha = 0.3
    }
    
    @objc func handleContinueButtonTapped() {
        if input1TextField.text != "1" || input2TextField.text != "1" || input3TextField.text ==  "1" &&
            input4TextField.text != "1" || input5TextField.text != "1" || input6TextField.text != "1" {
            self.wrongCodeLabel.isHidden = false
        } else {
            let homeController = HomeController()
            navigationController?.pushViewController(homeController, animated: true)
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            heightKeypad = keyboardSize.height
            bottomAnchorContinuteButtonToView.isActive = false
            bottomAnchorContinuteButtonToResendButton.isActive = true
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            heightKeypad = keyboardSize.height
            bottomAnchorContinuteButtonToView.isActive = true
            bottomAnchorContinuteButtonToResendButton.isActive = false
        }
    }
    
    @objc func hanldeTextFieldDidBegin(_ textField: UITextField) {
        guard let text = textField.text else {return }
        if textField.tag == 1 && text.count > 0 {
            textField.text = String(text.first!)
            enableInputTextField(index: 2)
            disableInputTextField(index: 1)
            input2TextField.becomeFirstResponder()
            return
        }

        if textField.tag == 2 && text.count > 0 {
            lastNumberCharacter[2] = 1
            textField.text = String(text.first!)
            enableInputTextField(index: 3)
            disableInputTextField(index: 2)
            input3TextField.becomeFirstResponder()
            return
        }

        if textField.tag == 3 && text.count > 0 {
            lastNumberCharacter[3] = 1
            textField.text = String(text.first!)
            enableInputTextField(index: 4)
            disableInputTextField(index: 3)
            input4TextField.becomeFirstResponder()
            return
        }

        if textField.tag == 4 && text.count > 0 {
            lastNumberCharacter[4] = 1
            textField.text = String(text.first!)
            enableInputTextField(index: 5)
            disableInputTextField(index: 4)
            input5TextField.becomeFirstResponder()
            return
        }

        if textField.tag == 5 && text.count > 0 {
            lastNumberCharacter[5] = 1
            textField.text = String(text.first!)
            enableInputTextField(index: 6)
            disableInputTextField(index: 5)
            input6TextField.becomeFirstResponder()
            return
        }

        if textField.tag == 6 && text.count > 0 {
            textField.text = String(text.first!)
            lastNumberCharacter[5] = 1
            self.enableContinuteButton()
        }
    }
    
}

extension LoginController: InputTextFieldDelegate {
    func textFieldDidDelete(_ textField: UITextField) {
        guard let text = textField.text else {return }
        self.disableContinuteButton()
        self.wrongCodeLabel.isHidden = true
        if textField.tag == 1 && text.count == 0  {
            return
        }

        if textField.tag == 2 && lastNumberCharacter[2] == 1 {
            lastNumberCharacter[2] = 0
            return
        } else if textField.tag == 2 && lastNumberCharacter[2] == 0 {
            enableInputTextField(index: 1)
            disableInputTextField(index: 2)
            input1TextField.becomeFirstResponder()
            input1TextField.text = ""
            lastNumberCharacter[1] = 0
        }
        
        if textField.tag == 3 && lastNumberCharacter[3] == 1 {
            lastNumberCharacter[3] = 0
            return
        } else if textField.tag == 3 && lastNumberCharacter[3] == 0 {
            enableInputTextField(index: 2)
            disableInputTextField(index: 3)
            input2TextField.becomeFirstResponder()
            input2TextField.text = ""
            lastNumberCharacter[2] = 0
        }
        
        if textField.tag == 4 && lastNumberCharacter[4] == 1 {
            lastNumberCharacter[4] = 0
            return
        } else if textField.tag == 4 && lastNumberCharacter[4] == 0 {
            enableInputTextField(index: 3)
            disableInputTextField(index: 4)
            input3TextField.becomeFirstResponder()
            input3TextField.text = ""
            lastNumberCharacter[3] = 0
        }
        
        if textField.tag == 5 && lastNumberCharacter[5] == 1 {
            lastNumberCharacter[5] = 0
            return
        } else if textField.tag == 5 && lastNumberCharacter[5] == 0 {
            enableInputTextField(index: 4)
            disableInputTextField(index: 5)
            input4TextField.becomeFirstResponder()
            input4TextField.text = ""
            lastNumberCharacter[4] = 0
        }
        
        if textField.tag == 6 && lastNumberCharacter[6] == 1 {
            lastNumberCharacter[6] = 0
            return
        } else if textField.tag == 6 && lastNumberCharacter[6] == 0 {
            enableInputTextField(index: 5)
            disableInputTextField(index: 6)
            input5TextField.becomeFirstResponder()
            input5TextField.text = ""
            lastNumberCharacter[5] = 0
        }

  
    
    }
}

