//
//  EditProfileFooter.swift
//  Twitter
//
//  Created by Long Bảo on 04/03/2023.
//

import Foundation
import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func didTapLogOutButton()
}

class EditProfileFooter: UIView {
    
    //MARK: - Properties
    weak var delegate: EditProfileFooterDelegate?
    private lazy var logOutButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Log Out", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleLogOutButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        print("DEBUG: EditFooterView Init")
        configureUI()
    }
    
    deinit {
        print("DEBUG: EditFooterView Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Hepers
    func configureUI() {
        backgroundColor = .white
        addSubview(logOutButton)
        logOutButton.topAnchor.constraint(equalTo: topAnchor).isActive = true
        logOutButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 35).isActive = true
        logOutButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -35).isActive = true
        logOutButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    //MARK: - Selectors
    @objc func handleLogOutButton() {
        delegate?.didTapLogOutButton()
    }
}
