//
//  FilmTableViewCell.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 04/02/2023.
//

import UIKit

class FilmTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    static let identifier = "FilmTableViewCell"

    let posterImageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let playButton: UIButton = {
        let button = UIButton(type: .system)
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.tintColor = .white
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: - View Liefcycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(posterImageView)
        addSubview(titleLabel)
        addSubview(playButton)
        applyConstrain()
    }
    
    func applyConstrain() {
        let posterImageViewConstraint = [
            posterImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            posterImageView.leftAnchor.constraint(equalTo: leftAnchor),
            posterImageView.widthAnchor.constraint(equalToConstant: 80)
        ]
        
        let titleLabelConstraint = [
            titleLabel.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            titleLabel.leftAnchor.constraint(equalTo: posterImageView.rightAnchor, constant: 40),
            titleLabel.widthAnchor.constraint(equalToConstant: 200)
        ]
        
        let playButtonConstraint = [
            playButton.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            playButton.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 30),
            playButton.heightAnchor.constraint(equalToConstant: 40),
            playButton.widthAnchor.constraint(equalTo: playButton.heightAnchor),
        ]
        
        NSLayoutConstraint.activate(posterImageViewConstraint)
        NSLayoutConstraint.activate(titleLabelConstraint)
        NSLayoutConstraint.activate(playButtonConstraint)
    }
    
}
