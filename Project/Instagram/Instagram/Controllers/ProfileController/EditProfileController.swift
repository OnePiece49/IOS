//
//  EditProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit

class EditProfileController: UIViewController {
    //MARK: - Properties
    private let tableView = UITableView(frame: .zero, style: .plain)
    let selectController = SelectTypePhotoController()
    var selectViewTopConstraint: NSLayoutConstraint!
    var isPresentingSelectVC = false
    
    var navigationBar: NavigationCustomView!
    
    
    private lazy var avatarImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 90 / 2
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditAvatarButtonTapped)))
        return iv
    }()
    
    private lazy var editAvatarButton: UIButton = {
        let button = UIButton()
        button.setTitle("Edit image or Avatar", for: .normal)
        button.setTitleColor(UIColor.systemCyan, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleEditAvatarButtonTapped)))
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    func setupNavigationBar() {
        view.backgroundColor = .systemBackground
        let attributeLeftButton = AttibutesButton(tilte: "Cancel",
                                                  font: UIFont.systemFont(ofSize: 16)) {
            self.dismiss(animated: true, completion: .none)
        }

        let attributeRightButton = AttibutesButton(tilte: "Done",
                                                   font: UIFont.systemFont(ofSize: 16, weight: .semibold),
                                                   titleColor: .systemBlue) {
            self.dismiss(animated: true, completion: .none)
        }
        
        self.navigationBar = NavigationCustomView(centerTitle: "Edit Profile",
                                                        attributeLeftButtons: [attributeLeftButton],
                                                        attributeRightBarButtons: [attributeRightButton])
    }
    
    func addChildController() {
        addChild(selectController)
        view.addSubview(selectController.view)
        didMove(toParent: self)
        
        guard let viewSelect = selectController.view else {return}
        viewSelect.translatesAutoresizingMaskIntoConstraints = false
        selectViewTopConstraint = viewSelect.topAnchor.constraint(equalTo: view.bottomAnchor)
        NSLayoutConstraint.activate([
            selectViewTopConstraint,
            viewSelect.widthAnchor.constraint(equalTo: view.widthAnchor),
            viewSelect.heightAnchor.constraint(equalToConstant: 300),
            viewSelect.leftAnchor.constraint(equalTo: view.leftAnchor)
        ])
        viewSelect.clipsToBounds = true
        viewSelect.layer.cornerRadius = 20
    }
    
    func removeChildController() {
        selectController.removeFromParent()
        selectController.view.removeFromSuperview()
        didMove(toParent: self)
    }

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        setupNavigationBar()
        activeConstraint()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.register(EditProfileTableViewCell.self,
                           forCellReuseIdentifier: EditProfileTableViewCell.identifier)
        shadowView.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                               action: #selector(handleEditAvatarButtonTapped)))
    }
    
    //MARK: - Selectors
    func activeConstraint() {

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
    
    
    @objc func handleEditAvatarButtonTapped() {
        
        if !isPresentingSelectVC {
            addChildController()
            self.view.layoutIfNeeded()
            UIView.animate(withDuration: 0.35) {
                self.selectViewTopConstraint.constant = -200
                self.shadowView.alpha = 0.8
                self.view.layoutIfNeeded()
            }
        } else {

            UIView.animate(withDuration: 0.35) {
                self.selectViewTopConstraint.constant = 0
                self.shadowView.alpha = 0
                self.view.layoutIfNeeded()
            }
            removeFromParent()
        }
        
        self.isPresentingSelectVC = !isPresentingSelectVC
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
            cell.cellData = EditProfileCell(type: EditProfileCellType(rawValue: indexPath.row) ?? .fullname, data: "Trịnh Tiến việt")
            
        } else if indexPath.row == 1 {
            cell.cellData = EditProfileCell(type: EditProfileCellType(rawValue: indexPath.row) ?? .fullname, data: "m.d.garp.49")
        } else {
            cell.cellData = EditProfileCell(type: EditProfileCellType(rawValue: indexPath.row) ?? .fullname)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            let bioVC = EditBioProfileController()
            bioVC.modalPresentationStyle = .fullScreen
            present(bioVC, animated: true, completion: .none)
        } else {
            let editInfoVC = EditDetailProfileViewController(type: EđitDetailProfileType(rawValue: indexPath.row) ?? .username)
            editInfoVC.modalPresentationStyle = .fullScreen
            present(editInfoVC, animated: true, completion: .none)

        }
    }
}
