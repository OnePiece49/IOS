//
//  ProfileHeader.swift
//  Twitter
//
//  Created by Long Bảo on 20/01/2023.
//

import UIKit
import SDWebImage

protocol ProfileHeaderDelegate: AnyObject {
    func handleDissmiss()
    func handleButtonTapped(_ header: ProfileHeader)
    func didSelect(filter: ProfileFilterOption)
}

class ProfileHeader: UICollectionReusableView {
    
    //MARK: - Properties
    var user: User? {
        didSet {
            configureFollowLabel()
        }
    }
    
    private let filterBar = ProfileFilterView()
    weak var delegate: ProfileHeaderDelegate?
    
    private lazy var containterView : UIView = {
       let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.setDimensions(width: 30, height: 30)
        backButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 42).isActive = true
        backButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "baseline_arrow_back_white_24dp"), for: .normal)
        button.addTarget(self, action: #selector(handleDismissTapped), for: .touchUpInside)
        return button
    }()
    
    lazy var profileImageView: UIImageView = {
       let image = UIImageView()
        image.backgroundColor = .twitterBlue
        image.clipsToBounds = true
        image.layer.borderColor = UIColor.white.cgColor
        image.layer.borderWidth = 4
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
    
    lazy var editButton: UIButton = {
        let button = UIButton()
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.setTitleColor(.twitterBlue, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        button.setTitle("Follow", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Viet Pro"
        return label
    }()
    
    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .lightGray
        label.text = "@m.d.garp.49"
        return label
    }()
    
    lazy var bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 3
        label.text = "This is a user bio will span more than one line for test purpuse"
        return label
    }()

    
    lazy var followingLabel: UILabel = {
        let label = UILabel()
        label.text = "0 Following"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapped)
        return label
    }()
    
    lazy var followersLabel: UILabel = {
        let label = UILabel()
        label.text = "2 Followers"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        let tapped = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.isUserInteractionEnabled = true
        label.addGestureRecognizer(tapped)
        return label
    }()

    private let replyLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    //MARK: - LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        print("DEBUG: ProfileHeader Init")
        configureUI()
    }
    
    deinit {
        print("DEBUG: ProfileHeader Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    //MARK: - Helpers
    func configureUI() {
        backgroundColor = .white
        addSubview(replyLabel)
        addSubview(containterView)
        addSubview(profileImageView)
        addSubview(editButton)
        containterView.heightAnchor.constraint(equalToConstant: 108).isActive = true
        containterView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        containterView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        containterView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        
        profileImageView.topAnchor.constraint(equalTo: containterView.bottomAnchor, constant: -24).isActive = true
        profileImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        profileImageView.setDimensions(width: 80, height: 80)
        profileImageView.layer.cornerRadius = 80 / 2
        
        editButton.setDimensions(width: 100, height: 36)
        editButton.topAnchor.constraint(equalTo: containterView.bottomAnchor, constant: 12).isActive = true
        editButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        editButton.layer.cornerRadius = 36 / 2
        
        let detailUserStack = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel, bioLabel])
        detailUserStack.axis = .vertical
        detailUserStack.translatesAutoresizingMaskIntoConstraints = false
        detailUserStack.distribution = .fillProportionally
        detailUserStack.spacing = 4
        addSubview(detailUserStack)
        detailUserStack.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 8).isActive = true
        detailUserStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        detailUserStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -12).isActive = true
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        addSubview(followStack)
        followStack.translatesAutoresizingMaskIntoConstraints = false
        followStack.axis = .horizontal
        followStack.distribution = .fillProportionally
        followStack.spacing = 5
        followStack.topAnchor.constraint(equalTo: detailUserStack.bottomAnchor, constant: 8).isActive = true
        followStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 12).isActive = true
        
        addSubview(filterBar)
        filterBar.translatesAutoresizingMaskIntoConstraints = false
        filterBar.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        filterBar.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        filterBar.heightAnchor.constraint(equalToConstant: 40).isActive = true
        filterBar.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        filterBar.delegate = self
    }
    
    func configureFollowLabel() {
        guard let user = user else { return }
        let viewModel = ProfileHeaderViewModel(user: user)
    
        let urlImageProfile = URL(string: user.profileImageURL)
        profileImageView.sd_setImage(with: urlImageProfile, completed: nil)
        editButton.setTitle(viewModel.actionButtonTitle, for: .normal)

        let viewmodel = ProfileHeaderViewModel(user: user)
        followersLabel.attributedText = viewmodel.followersString
        followingLabel.attributedText = viewmodel.followingString
        editButton.setTitle(viewmodel.actionButtonTitle, for: .normal)
        self.fullNameLabel.text = user.fullName
        self.userNameLabel.text = "@" + user.userName
        self.bioLabel.text = viewModel.bioString
    }
    
    //MARK: - Selectors
    @objc func handleDismissTapped() {
        delegate?.handleDissmiss()
    }
    
    @objc func handleEditProfileFollow() {
        delegate?.handleButtonTapped(self)
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
}


//MARK: - Properties
extension ProfileHeader: ProfileFilterViewDelegate {
    func didSelectFilter(indexPath: IndexPath, view: ProfileFilterView) {
        guard let filter = ProfileFilterOption(rawValue: indexPath.row) else {return}
        
        delegate?.didSelect(filter: filter)
    }

}
