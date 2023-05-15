//
//  HomeFeedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 14/05/2023.
//


import UIKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "ProfileCollectionViewCell"
    
    private lazy var avatarUserUpTusImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 36 / 2
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "black_pink"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemCyan
        return iv
    }()
    
    private lazy var heardImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "like1"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        iv.setDimensions(width: 30, height: 30)
        iv.contentMode = .scaleAspectFit

        return iv
    }()
    
    private lazy var commentImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "comment"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.tintColor = .black
        iv.setDimensions(width: 30, height: 30)

        iv.contentMode = .scaleAspectFit

        return iv
    }()
    
    private lazy var shareImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "share"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setDimensions(width: 35, height: 35)
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var saveImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Bookmark"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.setDimensions(width: 35, height: 35)

        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private lazy var actionStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [heardImageView,
                                                   commentImageView,
                                                   shareImageView])
        stack.axis = .horizontal
        stack.spacing = 13
        stack.distribution = .equalCentering
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let numberLikedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "102 lượt thích"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    private lazy var statusLabel: UILabel = Utilites.createStatusFeedLabel(username: "black_pink", status: "Happy birthday Blackpink, have a good day, wish you have all lucky :))")
    
    private lazy var getCommentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Xem 1531 bình luận"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private let timePostTusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "27 minutes ago"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .black
        return label
    }()
    
    private lazy var fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .red
        
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
        self.activeConstraint()
    }
    
    func activeConstraint() {
        addSubview(avatarUserUpTusImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(actionStackView)
        addSubview(saveImageView)
        addSubview(numberLikedLabel)
        addSubview(statusLabel)
        addSubview(getCommentLabel)
        addSubview(timePostTusLabel)
        addSubview(fakeView)
        
        NSLayoutConstraint.activate([
            avatarUserUpTusImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarUserUpTusImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 6)
        ])
        avatarUserUpTusImageView.setDimensions(width: 36, height: 36)
        
        NSLayoutConstraint.activate([
            usernameLabel.centerYAnchor.constraint(equalTo: avatarUserUpTusImageView.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: avatarUserUpTusImageView.rightAnchor, constant: 9),
        ])
        
        NSLayoutConstraint.activate([
            photoImageView.topAnchor.constraint(equalTo: avatarUserUpTusImageView.bottomAnchor, constant: 7),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
        ])
        photoImageView.setDimensions(width: bounds.width, height: 350)
        
        NSLayoutConstraint.activate([
            actionStackView.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 10),
            actionStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            actionStackView.heightAnchor.constraint(equalToConstant: 35),
        ])
        
        NSLayoutConstraint.activate([
            saveImageView.centerYAnchor.constraint(equalTo: actionStackView.centerYAnchor),
            saveImageView.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
        ])
        
        NSLayoutConstraint.activate([
            numberLikedLabel.topAnchor.constraint(equalTo: actionStackView.bottomAnchor, constant: 11),
            numberLikedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            numberLikedLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
        ])
        
        NSLayoutConstraint.activate([
            statusLabel.topAnchor.constraint(equalTo: numberLikedLabel.bottomAnchor, constant: 11),
            statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),

        ])
        
        NSLayoutConstraint.activate([
            getCommentLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 11),
            getCommentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            getCommentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),

        ])
        
        NSLayoutConstraint.activate([
            timePostTusLabel.topAnchor.constraint(equalTo: getCommentLabel.bottomAnchor, constant: 6),
            timePostTusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            timePostTusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            timePostTusLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        

    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate

