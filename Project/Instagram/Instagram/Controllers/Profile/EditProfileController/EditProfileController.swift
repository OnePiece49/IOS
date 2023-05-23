//
//  EditProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit
import SDWebImage

protocol EditProfileDelegate: AnyObject {
    func didUpdateProfile(user: User, image: UIImage?)
}

class EditProfileController: UIViewController {
    //MARK: - Properties
    var user: User
    private let tableView = UITableView(frame: .zero, style: .plain)
    let selectController = SelectTypePhotoController()
    var selectViewTopConstraint: NSLayoutConstraint!    
    var navigationBar: NavigationCustomView!
    weak var delegate: EditProfileDelegate?
    var oldImage: UIImage?
    let oldUser: User
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 90 / 2
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                       action: #selector(handleEditAvatarButtonTapped)))
        return iv
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit image or Avatar", for: .normal)
        button.setTitleColor(UIColor.systemCyan, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                           action: #selector(handleEditAvatarButtonTapped)))
        return button
    }()
    
    private let avatarDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    
    private let shadowView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    //MARK: - View Lifecycle
    init(user: User) {
        self.user = user
        self.oldUser = user
        
        super.init(nibName: nil, bundle: nil)
        
        let url = URL(string: user.profileImage ?? "")
        self.avatarImageView.sd_setImage(with: url,
                                        placeholderImage: UIImage(systemName: "person.circle"))
        self.oldImage = avatarImageView.image
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("DEBUG: EditProfileController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBar()
        configureUI()
        configureProperties()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        let attributeLeftButton = AttibutesButton(tilte: "Cancel",
                                                  font: UIFont.systemFont(ofSize: 16)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }

        let attributeRightButton = AttibutesButton(tilte: "Done",
                                                   font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                   titleColor: .systemBlue) { [weak self] in

            self?.updateInfo()
        }
        
        self.navigationBar = NavigationCustomView(centerTitle: "Edit Profile",
                                                  attributeLeftButtons: [attributeLeftButton],
                                                  attributeRightBarButtons: [attributeRightButton])
    }
    

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(navigationBar)
        view.addSubview(avatarImageView)
        view.addSubview(editAvatarButton)
        view.addSubview(avatarDivider)
        view.addSubview(tableView)
        view.addSubview(shadowView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            navigationBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 45),
          
            avatarImageView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 12),
            avatarImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            editAvatarButton.topAnchor.constraint(equalTo: avatarImageView.bottomAnchor, constant: 8),
            editAvatarButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            avatarDivider.topAnchor.constraint(equalTo: editAvatarButton.bottomAnchor, constant: 6),
            avatarDivider.leftAnchor.constraint(equalTo: view.leftAnchor),
            avatarDivider.rightAnchor.constraint(equalTo: view.rightAnchor),
            avatarDivider.heightAnchor.constraint(equalToConstant: 0.5),
            
            tableView.topAnchor.constraint(equalTo: avatarDivider.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            shadowView.topAnchor.constraint(equalTo: view.topAnchor),
            shadowView.leftAnchor.constraint(equalTo: view.leftAnchor),
            shadowView.rightAnchor.constraint(equalTo: view.rightAnchor),
            shadowView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        avatarImageView.setDimensions(width: 90, height: 90)
    }
    
    //MARK: - Selectors
    func configureProperties() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(EditProfileTableViewCell.self,
                           forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(handleEditAvatarButtonTapped)))
    }
    
    
    @objc func handleEditAvatarButtonTapped() {
        let selectedVC = SelectTypePhotoController()
        selectedVC.modalPresentationStyle = .overFullScreen
        selectedVC.delegate = self
        
        UIView.animate(withDuration: 0.23) {
            self.shadowView.alpha = 0.8
        }
        selectedVC.durationDismissing = {
            UIView.animate(withDuration: 0.23) {
                self.shadowView.alpha = 0.0
            }
        }
        self.present(selectedVC, animated: false, completion: .none)
    }
    
    func hasChangeOtherInfo() -> Bool {
        if oldUser.fullname != user.fullname || oldUser.bio != user.bio || oldUser.username != user.username {
            return false
        }
        
        return true
    }
    
    func hasChangeAvatar() -> Bool {
        if self.oldImage != self.avatarImageView.image {
            return false
        }
        
        return true
    }
    
    func updateInfo() {
        if !hasChangeAvatar() && !hasChangeOtherInfo() {
            navigationController?.popViewController(animated: true)
        }
        
        if hasChangeAvatar() && hasChangeOtherInfo() {
            UserService.shared.updateInfoUser(user: user, image: avatarImageView.image) {
                self.delegate?.didUpdateProfile(user: self.user, image: self.avatarImageView.image)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
        if !hasChangeAvatar() && hasChangeOtherInfo() {
            UserService.shared.updateInfoUser(user: user, image: nil) {
                self.delegate?.didUpdateProfile(user: self.user, image: self.avatarImageView.image)
                self.navigationController?.popViewController(animated: true)
            }
        }
    }
    
}
//MARK: - delegate
extension EditProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileCellType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EditProfileTableViewCell.identifier, for: indexPath) as! EditProfileTableViewCell
        
        if indexPath.row == 0 {
            cell.cellData = EditProfileCellData(type: EditProfileCellType(rawValue: indexPath.row) ?? .fullname,
                                            data: user.fullname)
            
        } else if indexPath.row == 1 {
            cell.cellData = EditProfileCellData(type: EditProfileCellType(rawValue: indexPath.row) ?? .username,
                                            data: user.username)
        } else if indexPath.row == 2 {
            cell.cellData = EditProfileCellData(type: EditProfileCellType(rawValue: indexPath.row) ?? .bio,
                                            data: user.bio ?? "")
        } else {
            cell.cellData = EditProfileCellData(type: EditProfileCellType(rawValue: indexPath.row) ?? .link,
                                            data: user.link ?? "")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let bioVC = EditBioProfileController(bio: user.bio ?? "")
            bioVC.delegate = self
            self.navigationController?.pushViewController(bioVC, animated: true)
        } else {
            var row: Int = indexPath.row
            if indexPath.row == 3 {
                row -= 1
            }
            let editInfoVC = EditDetailProfileViewController(type: EđitDetailProfileType(rawValue: row)!,
                                                             user: self.user)
            editInfoVC.delegate = self
            self.navigationController?.pushViewController(editInfoVC, animated: true)

        }
    }
}


extension EditProfileController: SelectTypePhotoDelegate {
    func didSelectChooseLibrary(_ viewController: BottomSheetViewCustomController) {
        let pickVC = PickPhotoController(type: .changeAvatar)
        pickVC.delegate = self
        navigationController?.pushViewController(pickVC, animated: true)
        viewController.animationDismiss()
    }
    
    func didSelectChooseTakePicture(_ viewController: BottomSheetViewCustomController) {
        let camVC = CameraController()
        navigationController?.pushViewController(camVC, animated: true)
        viewController.animationDismiss()
    }
}

extension EditProfileController: PickPhotoDelegate {
    func didSelectNextButton(image: UIImage?) {
        self.avatarImageView.image = image
    }
}


extension EditProfileController: EditBioDelegate {
    func didSelectDoneButton(text: String) {
        user.bio = text
        
        let indexPath = IndexPath(row: 2, section: 0)
        let cell = tableView.cellForRow(at: indexPath) as! EditProfileTableViewCell
        cell.cellData = EditProfileCellData(type: .bio, data: text)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

extension EditProfileController: EditDetailDelegate {
    func didSelectDoneButton(type: EđitDetailProfileType, text: String) {
        let indexPath: IndexPath
        switch type {
        case .fullname:
            indexPath = IndexPath(row: 0, section: 0)
            self.user.fullname = text
        case .username:
            indexPath = IndexPath(row: 1, section: 0)
            self.user.username = text
        case .link:
            indexPath = IndexPath(row: 3, section: 0)
            self.user.link = text
        }
    
        let cell = tableView.cellForRow(at: indexPath) as! EditProfileTableViewCell
        
        switch type {
        case .fullname:
            cell.cellData = EditProfileCellData(type: .fullname, data: text)
        case .username:
            cell.cellData = EditProfileCellData(type: .username, data: text)
        case .link:
            cell.cellData = EditProfileCellData(type: .link, data: text)
        }
    }
    
    
}
