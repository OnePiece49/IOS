//
//  NewsTableViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 08/03/2023.
//

import Foundation
import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "NewsTableViewCell"
    var viewModel: NewsViewModel? {
        didSet {configure()}
    }
    lazy var titleImage: UIImageView = {
         let iv = UIImageView(image: UIImage(named: "Image"))
         iv.translatesAutoresizingMaskIntoConstraints = false
         iv.contentMode = .scaleToFill
         iv.layer.cornerRadius = 16
         iv.clipsToBounds = true

        return iv
    }()
    
    private lazy var mainNewsTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 12)
        label.textColor =  UIColor(red: 0.071, green: 0.071, blue: 0.071, alpha: 1)
        label.textAlignment = .left
        label.text = "Jio Health khởi động chương trình Doctor Tour 2021"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Regular", size: 12)
        label.textColor =  UIColor(red: 0.492, green: 0.516, blue: 0.596, alpha: 1)
        label.textAlignment = .center
        label.text = "23 tháng 6 2021"
        return label
    }()
    
//    private lazy var stackTitle: UIStackView = {
//        let stack = UIStackView(arrangedSubviews: [mainTitleLabel, subTitleLabel])
//        stack.axis = .vertical
//        stack.spacing = 4
//        stack.translatesAutoresizingMaskIntoConstraints = false
//        stack.alignment = .top
//        mainTitleLabel.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
//        return stack
//    }()
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(titleImage)
        titleImage.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
        titleImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleImage.widthAnchor.constraint(equalTo: titleImage.heightAnchor, multiplier: 150 / 78).isActive = true
        titleImage.heightAnchor.constraint(equalToConstant: 78).isActive = true
        titleImage.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12).isActive = true
        
        
        addSubview(mainNewsTitleLabel)
        addSubview(dateLabel)
        mainNewsTitleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 13).isActive = true
        mainNewsTitleLabel.leftAnchor.constraint(equalTo: titleImage.rightAnchor, constant: 12).isActive = true
        mainNewsTitleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        dateLabel.topAnchor.constraint(equalTo: mainNewsTitleLabel.bottomAnchor, constant: 4).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: titleImage.rightAnchor, constant: 12).isActive = true

    }
    
    func configure() {
        guard let viewModel = viewModel else {
            return
        }

        titleImage.sd_setImage(with: viewModel.imageArticleUrl, completed: .none)
        mainNewsTitleLabel.text = viewModel.titleArticleString
        dateLabel.text = viewModel.dateArticleString
    }
}
