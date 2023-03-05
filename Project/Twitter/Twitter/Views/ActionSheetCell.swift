//
//  ActionSheetCell.swift
//  Twitter
//
//  Created by Long Bảo on 24/02/2023.
//

import Foundation
import UIKit

class ActionSheetCell: UITableViewCell {
    
    //MARK: - Properties
    var option: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    
    private let optionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "twitter_logo_blue")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 18)
        label.text = "Test Option"
        return label
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
        addSubview(optionImageView)
        addSubview(titleLabel)
        optionImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        optionImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        optionImageView.setDimensions(width: 36, height: 36)
        
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: optionImageView.rightAnchor, constant: 12).isActive = true
    }
    
    func configure() {
        self.titleLabel.text = option?.description
    }
    
    //MARK: - Selectors

}
