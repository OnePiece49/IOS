//
//  HeaderProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 06/05/2023.
//

import UIKit

enum HeaderType: String {
    case posts
    case followers
    case following
}

class HeaderProfileView: UICollectionReusableView {
    //MARK: - Properties
    static let identifier = "HeaderProfileView"
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    private var leftAnchorDivider: NSLayoutConstraint!
    weak var delegate: HeaderProfileViewDelegate?
    var heightBioConstraint: NSLayoutConstraint!
    var storyAvatarLayer: InstagramStoryLayer!
    var isRunningAnimationStory = false
    
    private lazy var postLabel = Utilites.createHeaderProfileInfoLabel(type: .posts, with: "80")
    private lazy var followersLabel = Utilites.createHeaderProfileInfoLabel(type: .followers, with: "428.5k")
    private lazy var followingLabel = Utilites.createHeaderProfileInfoLabel(type: .following, with: "60k")
    private lazy var editButton = Utilites.createHeaderProfileButton(with: "Edit")
    private lazy var shareButton = Utilites.createHeaderProfileButton(with: "Share")

    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [postLabel, followersLabel, followingLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        stackView.alignment = .fill
        return stackView
    }()
    
    private lazy var usernameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "m.d.garp.49"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textAlignment = .left
        return label
    }()
    
    private lazy var lineButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "line.3.horizontal"), for: .normal)
        button.contentMode = .scaleToFill
        button.tintColor = .black
        return button
    }()
    
    private lazy var usernameContainerView: UIView = {
        let view = UIView()
        view.addSubview(usernameLabel)
        view.addSubview(lineButton)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15),
            usernameLabel.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        
        NSLayoutConstraint.activate([
            lineButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            lineButton.topAnchor.constraint(equalTo: view.topAnchor),
        ])
        lineButton.setDimensions(width: 30, height: 26)
        return view
    }()
    
    private lazy var fullnameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Trịnh Tiến Việt"
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Hello everyone \nI'm viet \nNice to meet you guys \nRất vui được làm quen các bạn \n\n\n Xin chao moi nguoi nhe"
        label.numberOfLines = 2
        label.textAlignment = .left
        return label
    }()
    
    private lazy var readMoreButton: UIButton = {
        let button = UIButton()
        button.setTitle("Read more", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDidTapReadMoreButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var avartImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "jennie"))
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 100 / 2
        iv.contentMode = .scaleAspectFill
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action:
                                                        #selector(handleAvatarImageStoryTapped)))
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
        ])
        
        NSLayoutConstraint.activate([
            shareButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
            shareButton.topAnchor.constraint(equalTo: view.topAnchor),
            shareButton.widthAnchor.constraint(equalTo: editButton.widthAnchor),
            shareButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        return view
    }()
        
    private lazy var containerInfoView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(usernameContainerView)
        view.addSubview(avartImageView)
        view.addSubview(infoStackView)
        view.addSubview(fullnameLabel)
        view.addSubview(bioLabel)
        view.addSubview(readMoreButton)
        view.addSubview(containerButtonView)
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            usernameContainerView.topAnchor.constraint(equalTo: view.topAnchor),
            usernameContainerView.leftAnchor.constraint(equalTo: view.leftAnchor),
            usernameContainerView.rightAnchor.constraint(equalTo: view.rightAnchor),
            usernameContainerView.heightAnchor.constraint(equalToConstant: 25),
        ])
        
        NSLayoutConstraint.activate([
            avartImageView.topAnchor.constraint(equalTo: usernameContainerView.bottomAnchor, constant: 20),
            avartImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
        ])
        avartImageView.setDimensions(width: 100, height: 100)
        
        NSLayoutConstraint.activate([
            infoStackView.centerYAnchor.constraint(equalTo: avartImageView.centerYAnchor),
            infoStackView.leftAnchor.constraint(equalTo: avartImageView.rightAnchor, constant: 38),
            infoStackView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20),
        ])
        
        NSLayoutConstraint.activate([
            fullnameLabel.centerXAnchor.constraint(equalTo: avartImageView.centerXAnchor),
            fullnameLabel.topAnchor.constraint(equalTo: avartImageView.bottomAnchor, constant: 8),
            fullnameLabel.widthAnchor.constraint(equalToConstant: 120),
        ])
        
        NSLayoutConstraint.activate([
            readMoreButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
            readMoreButton.bottomAnchor.constraint(equalTo: bioLabel.bottomAnchor),
        ])
        
        self.heightBioConstraint = bioLabel.heightAnchor.constraint(equalToConstant: 34)
        NSLayoutConstraint.activate([
            bioLabel.topAnchor.constraint(equalTo: fullnameLabel.bottomAnchor, constant: 8),
            bioLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20),
            bioLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -25),
        ])
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 18),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: 88),
        ])
        
        NSLayoutConstraint.activate([
            containerButtonView.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 15),
            containerButtonView.leftAnchor.constraint(equalTo: view.leftAnchor),
            containerButtonView.rightAnchor.constraint(equalTo: view.rightAnchor),
            containerButtonView.heightAnchor.constraint(equalToConstant: 34),
            containerButtonView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -7),
        ])
        
        view.layoutIfNeeded()

        
        self.storyAvatarLayer = InstagramStoryLayer(centerPoint: CGPoint(x: avartImageView.bounds.midX, y: avartImageView.bounds.midY), width: avartImageView.bounds.width + 2, lineWidth: 4)
        avartImageView.layer.addSublayer(storyAvatarLayer)
        avartImageView.layer.masksToBounds = false
        self.cropImage()
        return view
    }()
    
    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        configureUI()
        cropImage()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(containerInfoView)
        
        NSLayoutConstraint.activate([
            containerInfoView.topAnchor.constraint(equalTo: topAnchor),
            containerInfoView.leftAnchor.constraint(equalTo: leftAnchor),
            containerInfoView.rightAnchor.constraint(equalTo: rightAnchor),
            containerInfoView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
        
        collectionView.collectionViewLayout = createLayoutCollectionView()
        collectionView.register(StoryCollectionViewCell.self, forCellWithReuseIdentifier: StoryCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false

    }
    
    func createStorySection() -> NSCollectionLayoutSection {
        let item = ComposionalLayout.createItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
        let group = ComposionalLayout.createGroup(axis:
                                                        .horizontal,
                                                  layoutSize:
                                                        .init(widthDimension: .absolute(60), heightDimension: .absolute(100)),
                                                  item: item, count: 1)
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
    
    
    func cropImage() {
        let maskLayer = CAShapeLayer()
        maskLayer.path = UIBezierPath(roundedRect: avartImageView.bounds, cornerRadius: avartImageView.bounds.width / 2).cgPath
        avartImageView.layer.mask = maskLayer
        
        let sourceImage = UIImage(
            named: "jennie"
        )!

        // The shortest side
        let sideLength = min(
            sourceImage.size.width,
            sourceImage.size.height
        )

        // Determines the x,y coordinate of a centered
        // sideLength by sideLength square
        let sourceSize = sourceImage.size
        let xOffset = (sourceSize.width - sideLength) / 2.0
        let yOffset = (sourceSize.height - sideLength) / 2.0

        // The cropRect is the rect of the image to keep,
        // in this case centered
        let cropRect = CGRect(
            x: xOffset,
            y: yOffset,
            width: sideLength,
            height: sideLength
        ).integral

        // Center crop the image
        let sourceCGImage = sourceImage.cgImage!
        let croppedCGImage = sourceCGImage.cropping(
            to: cropRect
        )!

        let image = UIImage(cgImage: croppedCGImage)
        avartImageView.image = image
    }
    
    //MARK: - Selectors
    @objc func handleDidTapReadMoreButton() {
        self.bioLabel.numberOfLines = 0
        let oldHeight = heightBioConstraint.constant
        
        NSLayoutConstraint.deactivate([heightBioConstraint])
        let rect = NSString(string: bioLabel.text ?? "").boundingRect(with: CGSize(width: bounds.width - 33, height: .greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: 14)], context: nil)
        self.heightBioConstraint.constant = rect.height

        containerInfoView.layoutIfNeeded()
        layoutIfNeeded()
        readMoreButton.isHidden = true
        self.delegate?.didTapReadMoreButton(oldHeight: oldHeight, newHeight: heightBioConstraint.constant)
    }
    
    @objc func handleAvatarImageStoryTapped() {
        if !isRunningAnimationStory {
            self.storyAvatarLayer.startAnimation()
        } else {
            self.storyAvatarLayer.stopAnimation()
        }
        
        isRunningAnimationStory = !isRunningAnimationStory
    }
    
}
//MARK: - delegate
extension HeaderProfileView: UICollectionViewDataSource, UICollectionViewDelegate {
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

protocol HeaderProfileViewDelegate: AnyObject {
    func didTapReadMoreButton(oldHeight: CGFloat, newHeight: CGFloat)
    
}
