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
    func didSelectCommentButton(cell: HomeFeedCollectionViewCell, status: InstaStatus)
    func didSelectNumberLikesButton(status: InstaStatus)
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
            viewModel?.fetchNumberUsersLikedStatus()
            viewModel?.fetchNumberUsersCommented()
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
        iv.contentMode = .scaleToFill
        iv.addSubview(heardLikemageView)
        NSLayoutConstraint.activate([
            heardLikemageView.centerXAnchor.constraint(equalTo: iv.centerXAnchor),
            heardLikemageView.centerYAnchor.constraint(equalTo: iv.centerYAnchor),
        ])
        heardLikemageView.setDimensions(width: 33, height: 25)
        let tapGeture = UITapGestureRecognizer(target: self,
                                               action: #selector(handelDoubleTapPhotoImageView))
        tapGeture.numberOfTapsRequired = 2
        iv.addGestureRecognizer(tapGeture)
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    private lazy var heardLikemageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "heart.fill"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        iv.isUserInteractionEnabled = true
        iv.isHidden = true
        iv.clipsToBounds = true
        iv.layer.masksToBounds = true
        iv.tintColor = .white
        return iv
    }()

    
    private let numberLikesButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("0 like", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        button.setTitleColor(.label, for: .normal)
        button.addTarget(self, action: #selector(handleNumberLikeButtonTapped), for: .touchUpInside)
        
        return button
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
        addSubview(numberLikesButton)
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
            
            numberLikesButton.topAnchor.constraint(equalTo: actionBar.bottomAnchor, constant: 2),
            numberLikesButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 15),
            
            statusLabel.topAnchor.constraint(equalTo: numberLikesButton.bottomAnchor, constant: 3),
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
            self?.didTapLikeButton()
        }
                                                   
        let attributeSecondLeftButton = AttibutesButton(image: UIImage(named: "comment-1"),
                                                        sizeImage: CGSize(width: 25, height: 25)) { [weak self] in
            self?.delegate?.didSelectCommentButton(cell: self!, status: self!.viewModel!.status)
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
        self.viewModel?.completionLike = {
            self.updateLikeButton()
        }
        
        self.viewModel?.completionFetchNumberLikes = {
            self.numberLikesButton.setTitle(self.viewModel?.numberLikesString, for: .normal)

        }
        
        self.viewModel?.completionFetchNumberUserCommented = {
            self.allCommentsButton.setTitle(self.viewModel?.numberCommmentsString, for: .normal)
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
    
    func didTapLikeButton() {
        guard let button = self.actionBar.leftButtons.first else {return}
        guard let hasLiked = viewModel?.likedStatus else {return}
        guard let viewModel = viewModel else {
            return
        }

        if hasLiked {
            viewModel.unlikeStatus()
        } else {
            viewModel.likeStatus()
        }
        
        let fakeNumberLikes = viewModel.numberLikesInt
        self.numberLikesButton.setTitle("\(fakeNumberLikes) likes ", for: .normal)

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
    }
    
    //MARK: - Selectors
    @objc func handelDoubleTapPhotoImageView() {
        didTapLikeButton()
        
        let transform = CGAffineTransform(scaleX: 120 / 25, y: 102 / 25)
        UIView.animate(withDuration: 0.3) {
            self.heardLikemageView.transform = transform
            self.heardLikemageView.isHidden = false
        } completion: { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.13) {
                self.heardLikemageView.transform = .identity
                self.heardLikemageView.isHidden = true
            }

        }
    }
    
    
    @objc func handleAvatarImageTapped() {
        guard let status = viewModel?.status else {return}
        self.delegate?.didSelectAvatar(status: status)
    }
    
    @objc func handelAllCommentButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didSelectCommentButton(cell: self, status: viewModel.status)
    }
    
    @objc func handleNumberLikeButtonTapped() {
        guard let viewModel = viewModel else {
            return
        }

        self.delegate?.didSelectNumberLikesButton(status: viewModel.status)
    }
    
}
//MARK: - delegate
extension HomeFeedCollectionViewCell: CommentDelegate {
    func didPostComment(numberComments: Int) {
        if numberComments == 0 {
            self.allCommentsButton.setTitle("Add comments...", for: .normal)
        } else if numberComments == 1  {
            self.allCommentsButton.setTitle("See all \(numberComments) comment", for: .normal)
        } else {
            self.allCommentsButton.setTitle("See all \(numberComments) comments", for: .normal)
        }
    }
}
