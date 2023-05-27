//
//  CommentCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 26/05/2023.
//


import UIKit

class CommentCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "CommentCollectionViewCell"
    var type: CommentType? {
        didSet {updateUI()}
    }
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jisoo"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 36 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 13, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .left
        label.text = "b_lackBink"
        return label
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "4 hour"
        return label
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    private lazy var captionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .label
        label.textAlignment = .left
        label.numberOfLines = 0
        label.text = """
        Cupid" của FIFTY FIFTY chính thức là bài hát trụ hạng lâu nhất của một nghệ sĩ nữ K-Pop trên Hot 100, vượt qua "Ice Cream" của BLACKPINK và Selena. Một thành tích quá khủng cho một tân binh.
        Thứ hạng tuần này của Cupid trên Hot 100: no.18
        """
        return label
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(avatarImageView)
        addSubview(usernameLabel)
        addSubview(dateLabel)
        addSubview(captionLabel)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            avatarImageView.topAnchor.constraint(equalTo: topAnchor, constant: 13),
            avatarImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            
            usernameLabel.topAnchor.constraint(equalTo: avatarImageView.topAnchor, constant: 0),
            usernameLabel.leftAnchor.constraint(equalTo: avatarImageView.rightAnchor, constant: 10),
            
            dateLabel.topAnchor.constraint(equalTo: usernameLabel.topAnchor),
            dateLabel.leftAnchor.constraint(equalTo: usernameLabel.rightAnchor, constant: 7),
            
            captionLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 2),
            captionLabel.leftAnchor.constraint(equalTo: usernameLabel.leftAnchor),
            captionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -22),
            captionLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12),
            
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
            divider.leftAnchor.constraint(equalTo: leftAnchor),
            divider.rightAnchor.constraint(equalTo: rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        avatarImageView.setDimensions(width: 36, height: 36)
    }
    
    func updateUI() {
        guard let type = type else {
            return
        }
        
        if type == .caption {
            divider.isHidden = false
        } else {
            divider.isHidden = true
        }
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

