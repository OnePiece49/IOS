//
//  SettingDoneTableViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit

class SettingDoneTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "SettingDoneTableViewCell"
    private let doneButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 48 / 2
        let attributedButton = NSMutableAttributedString(string: "Xong", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 17) ?? UIFont.boldSystemFont(ofSize: 17)])
        button.setAttributedTitle(attributedButton, for: .normal)
        button.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(handleContinueButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)
        button.alpha = 0.3
        button.isEnabled = false
        return button
    }()
    

    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        getNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Helpers
    func configureUI() {
        contentView.addSubview(doneButton)
        doneButton.topAnchor.constraint(equalTo: topAnchor, constant: 36).isActive = true
        doneButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        doneButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        doneButton.heightAnchor.constraint(equalTo: doneButton.widthAnchor, multiplier: 48 / 327).isActive = true
    }
    
    func getNotification() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "FetchDoneLocationUser"), object: .none, queue: .main) { _ in
            self.doneButton.alpha = 1
            self.doneButton.isEnabled = true
        }
    }
    
    //MARK: - Selectors
    @objc func handleContinueButtonTapped() {}
}
