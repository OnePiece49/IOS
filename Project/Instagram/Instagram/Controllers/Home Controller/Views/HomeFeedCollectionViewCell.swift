//
//  HomeFeedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 14/05/2023.
//


import UIKit
import SDWebImage

class HomeFeedCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    private var heightImageConstraint: NSLayoutConstraint!
    static let identifier = "HomeFeedCollectionViewCell"
    var actionBar: NavigationCustomView!
    var status: InstaStatus? {
        didSet {
            updateUI()
        }
    }
    
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
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    private lazy var photoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .systemCyan
        iv.contentMode = .scaleToFill
        return iv
    }()
    
    private let numberLikedLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "102 lượt thích"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    private lazy var statusLabel: UILabel = Utilites.createStatusFeedLabel(username: "black_pink", status: "Happy birthday Blackpink, have a good day, wish you have all lucky :))")
    
    private lazy var getCommentLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Xem 1531 bình luận"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
        return label
    }()
    
    private let timePostTusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "27 minutes ago"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .gray
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
        self.setupNavigationBar()
        addSubview(avatarUserUpTusImageView)
        addSubview(usernameLabel)
        addSubview(photoImageView)
        addSubview(actionBar)
        addSubview(numberLikedLabel)
        addSubview(statusLabel)
        addSubview(getCommentLabel)
        addSubview(timePostTusLabel)
        addSubview(fakeView)
        
        heightImageConstraint = photoImageView.heightAnchor.constraint(equalToConstant: 500)
        let bottomAnchor =  timePostTusLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        bottomAnchor.priority = UILayoutPriority(999)
        NSLayoutConstraint.activate([
            avatarUserUpTusImageView.topAnchor.constraint(equalTo: topAnchor),
            avatarUserUpTusImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 11),
            
            usernameLabel.centerYAnchor.constraint(equalTo: avatarUserUpTusImageView.centerYAnchor),
            usernameLabel.leftAnchor.constraint(equalTo: avatarUserUpTusImageView.rightAnchor, constant: 9),
            
            photoImageView.topAnchor.constraint(equalTo: avatarUserUpTusImageView.bottomAnchor, constant: 7),
            photoImageView.leftAnchor.constraint(equalTo: leftAnchor),
            photoImageView.widthAnchor.constraint(equalTo: widthAnchor),
            heightImageConstraint,
            
            actionBar.topAnchor.constraint(equalTo: photoImageView.bottomAnchor, constant: 9),
            actionBar.leftAnchor.constraint(equalTo: leftAnchor),
            actionBar.rightAnchor.constraint(equalTo: rightAnchor),
            actionBar.heightAnchor.constraint(equalToConstant: 35),
            
            numberLikedLabel.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 7),
            numberLikedLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            numberLikedLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
            statusLabel.topAnchor.constraint(equalTo: numberLikedLabel.bottomAnchor, constant: 7),
            statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            getCommentLabel.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 7),
            getCommentLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            getCommentLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),

            timePostTusLabel.topAnchor.constraint(equalTo: getCommentLabel.bottomAnchor, constant: 5),
            timePostTusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            timePostTusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            bottomAnchor,
        ])
        avatarUserUpTusImageView.setDimensions(width: 36, height: 36)
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "like1"),
                                                  sizeImage: CGSize(width: 23, height: 23))
                                                   
        let attributeSecondLeftButton = AttibutesButton(image: UIImage(named: "comment"),
                                                        sizeImage: CGSize(width: 23, height: 23))
                                                        
        let attributeThreeLeftButton = AttibutesButton(image: UIImage(named: "share"),
                                                  sizeImage: CGSize(width: 28, height: 28))
        
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "Bookmark"),
                                                  sizeImage: CGSize(width: 36, height: 32))
                                                   
        self.actionBar = NavigationCustomView(attributeLeftButtons: [attributeFirstLeftButton,
                                                                         attributeSecondLeftButton,
                                                                         attributeThreeLeftButton],
                                                  attributeRightBarButtons: [attributeFirstRightButton],
                                                  isHiddenDivider: true,
                                                  beginSpaceLeftButton: 12,
                                                  beginSpaceRightButton: 13,
                                                  continueSpaceleft: 12)
    }
    
    func updateUI() {
        let avatarImageUrl = URL(string: status?.user.profileImage ?? "")
        let photoImageUrl = URL(string: status?.postImage.imageURL ?? "")
        
        NSLayoutConstraint.deactivate([heightImageConstraint])
        
        let ratio: CGFloat = CGFloat(1.0 / ( status?.postImage.aspectRatio ?? 1.0))
        heightImageConstraint = self.photoImageView.heightAnchor.constraint(equalTo: self.photoImageView.widthAnchor, multiplier: ratio)
        NSLayoutConstraint.activate([
            heightImageConstraint,
        ])
        
        avatarUserUpTusImageView.sd_setImage(with: avatarImageUrl, placeholderImage: UIImage(systemName: "person.circle"))
        photoImageView.sd_setImage(with: photoImageUrl)
        usernameLabel.text = status?.user.username

        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a • MM/dd/yyyy"
        self.timePostTusLabel.text = formatter.string(from: self.status!.timeStamp)
        layoutIfNeeded()
    }
    
    
    //MARK: - Selectors
    
}
//MARK: - delegate

