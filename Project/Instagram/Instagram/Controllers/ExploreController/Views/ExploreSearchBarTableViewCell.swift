//
//  ExploreSearchBarTableViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 24/05/2023.
//

import Foundation


import UIKit

class ExploreSearchBarTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "ExploreSearchBarTableViewCell"
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 44 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        label.numberOfLines = 0
        label.text = "m.d.garp.49"
        return label
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .gray
        label.text = "Trịnh Tiến Việt"
        label.numberOfLines = 0
        return label
    }()
    
    //MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(usernameLabel)
        contentView.addSubview(fullnameLabel)
        
        NSLayoutConstraint.activate([
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            avatarImageView.centerYAnchor.constraint(equalTo: centerYAnchor),
            
            usernameLabel.bottomAnchor.constraint(equalTo: centerYAnchor, constant: -0.5),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 14),
            usernameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            
            fullnameLabel.topAnchor.constraint(equalTo: centerYAnchor, constant: 0.5),
            fullnameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            fullnameLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -14),
            
        ])
        avatarImageView.setDimensions(width: 44, height: 44)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

