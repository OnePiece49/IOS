//
//  HomeFeedCollectionViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 14/05/2023.
//


import UIKit
import SDWebImage

protocol HomeFeedCollectionViewCellDelegate: AnyObject {
    func didSelectAvatar(status: InstaStatus)
    func didSelectCommentButton(status: InstaStatus)
}

class HomeFeedCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    private var heightImageConstraint: NSLayoutConstraint!
    static let identifier = "HomeFeedCollectionViewCell"
    var actionBar: NavigationCustomView!
    weak var delegate: HomeFeedCollectionViewCellDelegate?
    var viewModel: HomeFeedCellViewModel? {
        didSet {
            updateUI()
            viewModel?.hasLikedStatus()
            configureProperties()
        }
    }
    
    private lazy var avatarUserUpTusImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 36 / 2
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleAvatarImageTapped)))
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "black_pink"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleAvatarImageTapped)))
        label.isUserInteractionEnabled = true
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
    
    private lazy var statusLabel: UILabel = Utilites.createStatusFeedLabel(username: "black_pink",
                                                                           status: "Happy birthday Blackpink, have a good day, wish you have all lucky :))")
    
    private lazy var allCommentsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Xem 1311 bình luận", for: .normal)
        button.tintColor = .label
        button.addTarget(self, action: #selector(handelAllCommentButtonTapped), for: .touchUpInside)
        button.setTitleColor(.gray, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.textAlignment = .left
        button.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        return button
    }()
    
    private let timePostTusLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "27 minutes ago"
        label.font = .systemFont(ofSize: 12, weight: .regular)
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
        addSubview(allCommentsButton)
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
            
            statusLabel.topAnchor.constraint(equalTo: numberLikedLabel.bottomAnchor, constant: 5),
            statusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            statusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            allCommentsButton.topAnchor.constraint(equalTo: statusLabel.bottomAnchor, constant: 0),
            allCommentsButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),

            timePostTusLabel.topAnchor.constraint(equalTo: allCommentsButton.bottomAnchor, constant: 0),
            timePostTusLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            timePostTusLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            bottomAnchor,
        ])
        avatarUserUpTusImageView.setDimensions(width: 36, height: 36)
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "like1"),
                                                       sizeImage: CGSize(width: 25, height: 25)) { [weak self] in
            self!.didTapLikeButton(button: self!.actionBar.leftButtons[0])
        }
                                                   
        let attributeSecondLeftButton = AttibutesButton(image: UIImage(named: "comment-1"),
                                                        sizeImage: CGSize(width: 25, height: 25)) { [weak self] in
            self?.delegate?.didSelectCommentButton(status: self!.viewModel!.status)
        }
                                                        
        let attributeThreeLeftButton = AttibutesButton(image: UIImage(named: "share"),
                                                  sizeImage: CGSize(width: 29, height: 29))
        
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "Bookmark"),
                                                  sizeImage: CGSize(width: 34, height: 31))
                                                   
        self.actionBar = NavigationCustomView(attributeLeftButtons: [attributeFirstLeftButton,
                                                                    attributeSecondLeftButton,
                                                                    attributeThreeLeftButton],
                                              attributeRightBarButtons: [attributeFirstRightButton],
                                              isHiddenDivider: true,
                                              beginSpaceLeftButton: 15,
                                              beginSpaceRightButton: 15,
                                              continueSpaceleft: 15)
    }
    
    func configureProperties() {
        self.viewModel?.completion = {
            self.updateLikeButton()
        }
    }
    
    func updateUI() {
        NSLayoutConstraint.deactivate([heightImageConstraint])
        
        let ratio: CGFloat = viewModel?.ratioImage ?? 1
        heightImageConstraint = self.photoImageView.heightAnchor.constraint(equalTo: self.photoImageView.widthAnchor, multiplier: ratio)
        NSLayoutConstraint.activate([
            heightImageConstraint,
        ])
        
        avatarUserUpTusImageView.sd_setImage(with: viewModel?.avatarURL, placeholderImage: UIImage(systemName: "person.circle"))
        photoImageView.sd_setImage(with: viewModel?.photoURL)
        usernameLabel.text = viewModel?.username
        statusLabel.attributedText = viewModel?.attributedCaptionLabel
        self.timePostTusLabel.text = viewModel?.dateString
        layoutIfNeeded()
    }
    
    
    func updateLikeButton() {
        guard let hasLiked = viewModel?.likedStatus else {return}
        
        if hasLiked {
            self.actionBar.leftButtons[0].setImage(UIImage(named: "heart-red"), for: .normal)
            self.actionBar.leftButtons[0].tintColor = .red
        } else {
            self.actionBar.leftButtons[0].setImage(UIImage(named: "like1"), for: .normal)
            self.actionBar.leftButtons[0].tintColor = .label
        }
    }
    
    func didTapLikeButton(button: UIButton) {
        guard let hasLiked = viewModel?.likedStatus else {return}

        let transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        UIView.animate(withDuration: 0.15) {
            button.transform = transform
            if  hasLiked {
                button.setImage(UIImage(named: "like1"), for: .normal)
                button.tintColor = .label

            } else {
                button.setImage(UIImage(named: "heart-red"), for: .normal)
                button.tintColor = .red
            }
        } completion: { _ in
            button.transform = .identity
        }
        
        
        if hasLiked {
            viewModel?.unlikeStatus()
        } else {
            viewModel?.likeStatus()
        }
        
    }
    
    //MARK: - Selectors
    @objc func handleAvatarImageTapped() {
        guard let status = viewModel?.status else {return}
        self.delegate?.didSelectAvatar(status: status)
    }
    
    @objc func handelAllCommentButtonTapped() {
        self.delegate?.didSelectCommentButton(status: self.viewModel!.status)
    }
    
}
//MARK: - delegate

