//
//  EditProfileCell.swift
//  Twitter
//
//  Created by Long Bảo on 03/03/2023.
//

import Foundation
import UIKit

protocol EditProfileCellDelegate:AnyObject {
    func updateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: EditProfileCellDelegate?
    var viewModel: EditProfileViewModel? {
        didSet {
            configure()
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "text"
        return label
    }()
    
    lazy var inforTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.font = UIFont.systemFont(ofSize: 14)
        textField.textAlignment = .left
        textField.textColor = .twitterBlue
        textField.text = "Hello ae wibu"
        textField.addTarget(self, action: #selector(handleUpdateUserInfor), for: .editingDidEnd)
        return textField
    }()
    
    lazy var bioTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 14)
        textView.textColor = .twitterBlue
        textView.text = "Bio"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = true
        textView.isEditable = true
        textView.isSelectable = true
        return textView
    }()
    
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none  //Người dùng select cell thì ko có gì xảy ra
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(inforTextField)
        contentView.addSubview(bioTextView)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        inforTextField.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10).isActive = true
        inforTextField.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        inforTextField.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        
        bioTextView.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 10).isActive = true
        bioTextView.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        bioTextView.topAnchor.constraint(equalTo: topAnchor, constant: 4).isActive = true
        bioTextView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateUserInfor), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }
        
        inforTextField.isHidden = viewModel.shouldHideInforTextField
        bioTextView.isHidden = viewModel.shouldHideBioTextField
        titleLabel.text = viewModel.titletext
        inforTextField.text = viewModel.optionValue
        bioTextView.text = viewModel.optionValue
    }
    
    //MARK: - Selectors
    @objc func handleUpdateUserInfor() {
        self.delegate?.updateUserInfo(self)
    }
}
