//
//  EditProfileController.swift
//  Twitter
//
//  Created by Long Bảo on 03/03/2023.
//

import Foundation
import UIKit

private let reuseIdentifier = "EditProfileCell"
protocol EditProfileControllerDelegate: AnyObject {
    func didUpdateUserInfor()
}

class EditProfileController: UITableViewController {
    //MARK: - Properties
    private var user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private lazy var footerView = EditProfileFooter()
    weak var delegate: EditProfileControllerDelegate?
    private let imagePicker = UIImagePickerController()
    private var isChangedInforUser: Bool = false
    private var isChangeProfileImageUser: Bool = false
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    
    //MARK: - Life Cycle
    init(user: User) {
        self.user = user
        super.init(style: .plain)
        print("DEBUG: EditProfileController Init")
    }
    
    deinit {
        print("DEBUG: EditProfileController Deinit")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        configureTableView()
        configureImagePicker()
    }
    
    //MARK: - Helpers
    func configureNavigationBar() {
        let appearanceNav = UINavigationBarAppearance()
        appearanceNav.backgroundColor = .twitterBlue
        appearanceNav.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.compactAppearance = appearanceNav
        self.navigationController?.navigationBar.standardAppearance = appearanceNav
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearanceNav
        
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = UIBarStyle.black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.backgroundColor = .twitterBlue
        UINavigationBar.appearance().barTintColor = .twitterBlue
        UINavigationBar.appearance().backgroundColor = .twitterBlue
        navigationController?.navigationBar.tintColor = .white
        navigationItem.title = "Edit Profile"
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.cancel, target: self, action: #selector(handleCancelButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done, target: self, action: #selector(handleDoneButton))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 4, width: view.frame.width, height: 50)
        headerView.delegate = self
        footerView.delegate = self
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func updateUserInfo() {
        if isChangedInforUser && isChangeProfileImageUser {
            UserService.shared.updateUserInfor(user: user) {
                self.updateProfileImageUser()
                self.dismiss(animated: true, completion: .none)
            }
        }
        
        if isChangedInforUser && !isChangeProfileImageUser {
            UserService.shared.updateUserInfor(user: user) {
                self.dismiss(animated: true, completion: .none)
            }
        }
        
        if !isChangedInforUser && isChangeProfileImageUser {
            self.updateProfileImageUser()
            self.dismiss(animated: true, completion: .none)
        }
    }
    
    //MARK: - Selectors
    @objc func handleCancelButton() {
        dismiss(animated: true, completion: .none)
    }
    
    @objc func handleDoneButton() {
        self.updateUserInfo()
        delegate?.didUpdateUserInfor()
        dismiss(animated: true, completion: .none)
    }
    
    func updateProfileImageUser() {
        guard let selectedImage = selectedImage else {
            return
        }

        UserService.shared.updateProfileImage(image: selectedImage) {
            
        }
    }
}


//MARK: - Delegate Datasource/DelegateTabelView
extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! EditProfileCell
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return cell}
        cell.viewModel = EditProfileViewModel(user: user, option: option)
        cell.delegate = self
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return 0}
        return option == .bio ? 100 : 48
    }
}

//MARK: - Delegate EditProfileHeaderDelegate
extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangePhotoButton() {
        present(imagePicker, animated: true, completion: .none)
    }
}

//MARK: Delegate PickerView
extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        self.selectedImage = image
        self.isChangeProfileImageUser = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        dismiss(animated: true, completion: .none)
    }
}


//MARK: - Delegate EditProfileCellDelegate
extension EditProfileController: EditProfileCellDelegate  {
    func updateUserInfo(_ cell: EditProfileCell) {
        guard let viewModel = cell.viewModel else {return}
        self.isChangedInforUser = true
        navigationItem.rightBarButtonItem?.isEnabled = true
        switch viewModel.option {
        case .fullName:
            guard let fullName = cell.inforTextField.text else {return}
            user.fullName = fullName
        case .userName:
            guard let userName = cell.inforTextField.text else {return}
            user.userName = userName
        case .bio:
            guard let bio = cell.bioTextView.text else {return}
            user.bio = bio
        }
    
    }
}

//MARK: - Delegate EditProfileFooterDelegate
extension EditProfileController: EditProfileFooterDelegate {
    func didTapLogOutButton() {
        let logOutAlert = UIAlertController(title: "Are you sure to log out", message: .none, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { alertAction in
        }
        
        let logOutAction = UIAlertAction(title: "Log Out", style: .destructive) { alertAction in
            AuthService.shared.logOut()
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: .none)
        }
        logOutAlert.addAction(logOutAction)
        logOutAlert.addAction(cancelAction)
        present(logOutAlert, animated: true, completion: .none)
    }
}
