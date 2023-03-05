//
//  NotificationCell.swift
//  Twitter
//
//  Created by Long Bảo on 28/02/2023.
//

import Foundation
import UIKit
import SDWebImage

protocol NotificationCellDelegate: AnyObject {
    func didTapProfileImage(_ cell: NotificationCell)
    func didTapFollowButton(_ cell: NotificationCell)
}

class NotificationCell: UITableViewCell {

    //MARK: - Properties
    weak var delegate: NotificationCellDelegate?
    let refershControl = UIRefreshControl()
    var notification: Notification? {
        didSet {
            configureCell()
        }
    }
    
    private lazy var profileImageView: UIImageView = {
       let image = UIImageView()
        image.translatesAutoresizingMaskIntoConstraints = false
        image.backgroundColor = .twitterBlue
        image.setDimensions(width: 48, height: 48)
        image.clipsToBounds = true
        image.layer.cornerRadius = 48 / 2
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        image.addGestureRecognizer(tap)
        image.isUserInteractionEnabled = true

        return image
    }()
    
    private lazy var  followButton: UIButton = {
        let button = UIButton()
        button.setTitle("Loading", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleFollowButtonTapped), for: .touchUpInside)
        return button
    }()
    
     private let notificationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Vietdz vkl"
        return label
    }()
    
    //MARK: - Life Cycle
    deinit {
        print("DEBUG: NotificationCell Deinit")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Helpers
    func configureUI() {
        let stack = UIStackView(arrangedSubviews: [profileImageView, notificationLabel])
        stack.axis = .horizontal
        stack.alignment = .center
        contentView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: contentView.leftAnchor, constant: 12).isActive = true
        stack.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -12).isActive = true
        stack.spacing = 12
        
        contentView.addSubview(followButton)
        followButton.setDimensions(width: 92, height: 32)
        followButton.layer.cornerRadius = 32 / 2
        followButton.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        followButton.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
    func configureCell() {
        guard let notification = notification else {
            return
        }
        
        let viewmodel = NotificationViewModel(notification: notification)
        profileImageView.sd_setImage(with: viewmodel.progileImageURL)
        notificationLabel.attributedText = viewmodel.notificationText
        followButton.isHidden = viewmodel.shouldHideFollowButton
        followButton.setTitle(viewmodel.titleFollowButton, for: .normal)
        followButton.backgroundColor = viewmodel.backgroudColorButton
        followButton.setTitleColor(viewmodel.titleColorFollowButton, for: .normal)
    }
    
    //MARK: - Selectors
    @objc func handleProfileImageTapped() {
        self.delegate?.didTapProfileImage(self)
    }
    
    @objc func handleFollowButtonTapped() {
        self.delegate?.didTapFollowButton(self)
    }
    

}
