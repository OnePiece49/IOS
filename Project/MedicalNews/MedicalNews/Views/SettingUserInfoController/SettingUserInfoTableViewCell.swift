//
//  SettingUserInfoTableViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit

protocol SettingUserInfoTableViewCellDelegate: AnyObject {
    func didTapBackButton()
}

class SettingUserInfoTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: DoctorHeaderViewDelegate?
    static let reuseIdentifier = "SettingUserInfoTableViewCell"
    var viewModel: SettingUserInfoCellViewModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateView()
                return
            }
        }
    }

    private lazy var titleInputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        label.textColor =  UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)
        label.textAlignment = .left
        label.text = "Jio Health khởi động chương trình Doctor Tour 2021"
        label.numberOfLines = 0
        return label
    }()
    
     lazy var inputTextfield: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont(name: "NunitoSans-SemiBold", size: 15)
        textField.placeholder = "Nhập số điện thoại"
        textField.textColor = UIColor(red: 0.094, green: 0.098, blue: 0.122, alpha: 1)
        textField.addTarget(self, action: #selector(handleDidBeginTextField), for: .editingDidBegin)
         
         textField.addTarget(self, action: #selector(handleDidEndTextField), for: .editingDidEnd)
        textField.keyboardType = .asciiCapableNumberPad
        return textField
    }()
    
     let expandButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.widthAnchor.constraint(equalToConstant: 24).isActive = true
        button.heightAnchor.constraint(equalToConstant: 24).isActive = true
        button.setImage(UIImage(named: "Line"), for: .normal)
        button.addTarget(self, action: #selector(handleExpandButton), for: .touchUpInside)
        return button
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Helpers
    func configureUI() {
        contentView.addSubview(titleInputLabel)
        titleInputLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
        titleInputLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        
        contentView.addSubview(expandButton)
        expandButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        expandButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -13).isActive = true
        
        contentView.addSubview(inputTextfield)
        inputTextfield.topAnchor.constraint(equalTo: titleInputLabel.bottomAnchor, constant: 4).isActive = true
        inputTextfield.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        inputTextfield.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        
        contentView.addSubview(dividerView)
        dividerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true

        dividerView.backgroundColor = UIColor(rgb: 0xEEEFF4)
        dividerView.leftAnchor.constraint(equalTo: inputTextfield.leftAnchor).isActive = true
        dividerView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
    }
    
    func updateView() {
        guard let viewModel = viewModel else {
            return
        }
        
        let option = viewModel.option
        
        switch option {
        case .city:
            inputTextfield.isEnabled = false
        case .district:
            inputTextfield.isEnabled = false
        case .ward:
            inputTextfield.isEnabled = false
        case .address:
            inputTextfield.isEnabled = false
        case .typeBlood:
            inputTextfield.isEnabled = false
        case .name:
            inputTextfield.isEnabled = true
        case .lastname:
            inputTextfield.isEnabled = true
        case .date:
            inputTextfield.isEnabled = true
        case .sex:
            inputTextfield.isEnabled = true
        case .phoneNumber:
            inputTextfield.isEnabled = true
        case .email:
            inputTextfield.isEnabled = true
        }
        
        inputTextfield.placeholder = viewModel.placeholderString
        inputTextfield.text = viewModel.dataString
        titleInputLabel.text = viewModel.titleString
    }
    
    private func enableView() {
        self.dividerView.backgroundColor = UIColor(rgb: 0x2C8667)
        self.titleInputLabel.textColor = UIColor(rgb: 0x2C8667)
    }
    
    private func disableView() {
        self.dividerView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        self.titleInputLabel.textColor = UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)
    }
    
    //MARK: - Selectors
    @objc func handleExpandButton() {
        
    }
    
    @objc func handleDidBeginTextField() {
        self.enableView()
    }
 
    @objc func handleDidEndTextField() {
        self.disableView()
    }
}
