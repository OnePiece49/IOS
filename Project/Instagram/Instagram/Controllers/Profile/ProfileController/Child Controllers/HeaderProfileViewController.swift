//
//  HeaderProfileViewController.swift
//  Instagram
//
//  Created by Long Bảo on 22/05/2023.
//

import UIKit

enum HeaderType: String {
    case posts
    case followers
    case following
}

protocol HeaderProfileDelegate: AnyObject {
    func didSelectEditButton()
    func didTapthreeLineImageView()
    func didSelectUsernameButton()
}

class HeaderProfileViewController: UIViewController {
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var leftAnchorDivider: NSLayoutConstraint!
    weak var delegate: HeaderProfileDelegate?
    var storyAvatarLayer: InstagramStoryLayer!
    var isRunningAnimationStory = false
    var viewModel: HeaderProfileViewModel? {
        didSet {
            configureUI()
            updateUI()
        }
    }
    
    private lazy var postLabel = Utilites.createHeaderProfileInfoLabel(type: .posts, with: "80")
    private lazy var followersLabel = Utilites.createHeaderProfileInfoLabel(type: .followers, with: "428.5k")
    private lazy var followingLabel = Utilites.createHeaderProfileInfoLabel(type: .following, with: "60k")
    lazy var editButton = Utilites.createHeaderProfileButton(with: "Loading")
    private lazy var shareButton = Utilites.createHeaderProfileButton(with: "Share")
    
    private lazy var navigationBar: NavigationCustomView = {
        guard let viewModel = viewModel else {
            return NavigationCustomView(attributeLeftButtons: [],
                                        attributeRightBarButtons: [])
        }

        if viewModel.isCurrentUser {
            let attributeFirstLeftButton = AttibutesButton(image: UIImage(systemName: "lock"),
                                                           sizeImage: CGSize(width: 15, height: 15),
                                                           tincolor: .label) {  [weak self] in
                self?.delegate?.didSelectUsernameButton()
            }
            let attributeSecondLeftButton = AttibutesButton(tilte: "",
                                                            font: UIFont.systemFont(ofSize: 23, weight: .bold),
                                                            titleColor: .label) { [weak self] in
                self?.delegate?.didSelectUsernameButton()
            }
            let attributeThreeLeftButton = AttibutesButton(image: UIImage(systemName: "chevron.down"),
                                                           sizeImage: CGSize(width: 13, height: 10),
                                                           tincolor: .label) { [weak self] in
                self?.delegate?.didSelectUsernameButton()
            }
            
            let attributeFirstRightButton = AttibutesButton(image: UIImage(systemName: "line.3.horizontal"),
                                                            sizeImage: CGSize(width: 28, height: 25),
                                                            tincolor: .label) { [weak self] in
                self?.delegate?.didTapthreeLineImageView()
            }
            let attributeSecondRightButton = AttibutesButton(image: UIImage(systemName: "plus.app"),
                                                             sizeImage: CGSize(width: 28, height: 27),
                                                             tincolor: .label) { [weak self] in
                self?.delegate?.didTapthreeLineImageView()
            }

            let navigationBar = NavigationCustomView(attributeLeftButtons: [attributeFirstLeftButton,
                                                                             attributeSecondLeftButton,
                                                                             attributeThreeLeftButton],
                                                      attributeRightBarButtons: [attributeFirstRightButton,
                                                                                 attributeSecondRightButton],
                                                      isHiddenDivider: true,
                                                      beginSpaceLeftButton: 12,
                                                      beginSpaceRightButton: 13,
                                                      continueSpaceleft: 5,
                                                      continueSpaceRight: 15)
            return navigationBar
        } else {
            let attributeFirstLeftButton = AttibutesButton(image: UIImage(systemName: "chevron.backward"),
                                                           sizeImage: CGSize(width: 20, height: 25),
                                                           tincolor: .label) { [weak self] in
                self?.navigationController?.popViewController(animated: true)
            }
            
            let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "3cham"),
                                                           sizeImage: CGSize(width: 26, height: 25),
                                                           tincolor: .label)

            let navigationBar = NavigationCustomView(centerTitle: viewModel.username,
                                                     attributeLeftButtons: [attributeFirstLeftButton],
                                                     attributeRightBarButtons: [attributeFirstRightButton],
                                                     isHiddenDivider: true,
                                                     beginSpaceLeftButton: 12,
                                                     beginSpaceRightButton: 12)
            return navigationBar
        }
    }()

    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.spacing = -3
        return stackView
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trịnh Tiến Việt 123"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = ""
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private lazy var readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read more", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDidTapReadMoreButton), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    private lazy var stackViewLabel: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bioLabel,
                                                       readMoreButton])
        stackView.axis = .vertical
        stackView.spacing = -5
        stackView.alignment = .top
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var avartImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "person.circle"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.borderWidth = 8
        iv.layer.borderColor = UIColor.clear.cgColor
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 90 / 2
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleAvatarImageStoryTapped)))
        iv.isUserInteractionEnabled = true
        iv.layer.masksToBounds = true
        return iv
    }()
    
    private lazy var containerButtonView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(editButton)
        view.addSubview(shareButton)
        
        NSLayoutConstraint.activate([
            editButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            editButton.topAnchor.constraint(equalTo: view.topAnchor),
            editButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 2, constant: -(20 + 20 + 8) / 2),
            editButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shareButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            shareButton.topAnchor.constraint(equalTo: view.topAnchor),
            shareButton.widthAnchor.constraint(equalTo: editButton.widthAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }()
        
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureProperties()
    }
    
    deinit {
        print("DEBUG: HeaderProfileViewController deinit")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(avartImageView)
        view.addSubview(infoStackView)
        view.addSubview(fullnameLabel)
        view.addSubview(stackViewLabel)
        view.addSubview(containerButtonView)
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 40),
            
            avartImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 11),
            avartImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            
            infoStackView.centerYAnchor.constraint(equalTo: avartImageView.centerYAnchor),
            infoStackView.leftAnchor.constraint(equalTo: avartImageView.rightAnchor, constant: 31),
            infoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -22),
            
            fullnameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 13),
            fullnameLabel.topAnchor.constraint(equalTo: avartImageView.bottomAnchor, constant: 12),
            fullnameLabel.widthAnchor.constraint(equalToConstant: 120),
            
            stackViewLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 8),
            stackViewLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 23),
            stackViewLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -21),
            
            collectionView.topAnchor.constraint(equalTo: stackViewLabel.bottomAnchor, constant: 11),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 88),
            
            containerButtonView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            containerButtonView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerButtonView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerButtonView.heightAnchor.constraint(equalToConstant: 34),
            containerButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -7),
        ])
        avartImageView.setDimensions(width: 90, height: 90)
        view.layoutIfNeeded()
        self.storyAvatarLayer = InstagramStoryLayer(centerPoint: CGPoint(x: avartImageView.frame.midX,
                                                                         y: avartImageView.frame.midY),
                                                    width: avartImageView.frame.width + 14,
                                                    lineWidth: 3.5)
        view.layer.addSublayer(storyAvatarLayer)
    }
    
    func configureProperties() {
        collectionView.collectionViewLayout = createLayoutCollectionView()
        collectionView.register(StoryCollectionViewCell.self,
                                forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }
    
    func updateUI() {
        guard let viewModel = viewModel else {
            return
        }

        if viewModel.isCurrentUser {
            self.navigationBar.leftButtons[1].setTitle(viewModel.username, for: .normal)
        }
        
        self.fullnameLabel.text = viewModel.fullname
        self.bioLabel.text = viewModel.bio
        self.avartImageView.sd_setImage(with: viewModel.imageAvatarUrl,
                                        placeholderImage: UIImage(systemName: "person.circle"))

        if viewModel.isCurrentUser {
            editButton.setTitle("Edit", for: .normal)
            editButton.addTarget(self, action: #selector(handleEditButtonTapped), for: .touchUpInside)
        } else {
            editButton.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
            if viewModel.isFollowed {
                editButton.setTitle("Following", for: .normal)
                editButton.backgroundColor = .systemGray3
            } else {
                editButton.setTitle("Follow", for: .normal)
                editButton.backgroundColor = . systemBlue
            }
        }

        postLabel.attributedText = viewModel.attributedPosts
        followersLabel.attributedText  = viewModel.attributedFollowers
        followingLabel.attributedText = viewModel.attributedFollowings
        
        view.layoutIfNeeded()
        if bioLabel.isTruncated {
            readMoreButton.isHidden = false
        } else {
            readMoreButton.isHidden = true
        }
    }
    
    func updateAvatar(image: UIImage?) {
        if let image = image {
            self.avartImageView.image = image
        }
    }
        
    func createStorySection() -> NSCollectionLayoutSection {
        let itemSize: NSCollectionLayoutSize = .init(widthDimension: .fractionalWidth(1.0),
                                                    heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize: NSCollectionLayoutSize = .init(widthDimension: .absolute(60),
                                                      heightDimension: .absolute(100))
        let group = ComposionalLayout.createGroup(axis:.horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        section.interGroupSpacing = 25
        section.orthogonalScrollingBehavior = .continuous
        return section
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout(section: createStorySection())
        layout.configuration.interSectionSpacing = 10
        return layout
    }
    
    func updateDataFollowing(isFollowed: Bool) {
        guard let viewModel = viewModel else {
            return
        }

        viewModel.user.stats?.followers += isFollowed ? -1 : +1
        followersLabel.attributedText  = viewModel.attributedFollowers

        if isFollowed {
            self.editButton.setTitle("Follow", for: .normal)
            
        } else {
            self.editButton.setTitle("Following", for: .normal)
        }
        
    }
    
    func getAvatarImage() -> UIImage? {
        self.avartImageView.image
    }

    
    //MARK: - Selectors
    @objc func handleDidTapReadMoreButton() {
        self.bioLabel.numberOfLines = 0

        view.layoutIfNeeded()
        readMoreButton.isHidden = true
    }
    
    @objc func handleAvatarImageStoryTapped() {
        if !isRunningAnimationStory {
            self.storyAvatarLayer.startAnimation()
        } else {
            self.storyAvatarLayer.stopAnimation()
        }
        
        isRunningAnimationStory = !isRunningAnimationStory
    }
    
    @objc func handleEditButtonTapped() {
        delegate?.didSelectEditButton()
    }
    
    @objc func handleFollowButtonTapped() {
        
    }
    
    
}
//MARK: - delegate
extension HeaderProfileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: StoryCollectionViewCell.identifier, for: indexPath) as! StoryCollectionViewCell
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
}