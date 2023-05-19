//
//  SelectTypePhotoController.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit


class SelectTypePhotoController: UIViewController {
    //MARK: - Properties
    let tableView = UITableView(frame: .zero, style: .plain)
    
    private lazy var avatarUserImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.backgroundColor = .blue
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 40 / 2
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    deinit {
        print("DEBUG: SelectTypePhotoController deinit")
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemGray2
        tableView.backgroundColor = .systemGray2

        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.register(SelectedTypeTableViewCell.self,
                           forCellReuseIdentifier: SelectedTypeTableViewCell.identifier)
        tableView.isScrollEnabled = false
        
        
        activeConstraint()
    }
    
    func activeConstraint() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
 
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension SelectTypePhotoController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTypeTableViewCell.identifier, for: indexPath) as! SelectedTypeTableViewCell
        if indexPath.row == 0 {
            cell.dataTypeEditProfile = SelectedTypeCellData(title: "Choose from library", image: UIImage(systemName: "photo"))
        } else if indexPath.row == 1 {
            cell.dataTypeEditProfile = SelectedTypeCellData(title: "Take picture", image: UIImage(systemName: "camera"))
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.addSubview(self.avatarUserImageView)
        header.addSubview(self.divider)
        
        avatarUserImageView.setDimensions(width: 40, height: 40)
        NSLayoutConstraint.activate([
            avatarUserImageView.centerXAnchor.constraint(equalTo: header.centerXAnchor),
            avatarUserImageView.topAnchor.constraint(equalTo: header.topAnchor, constant: -5),
            
            divider.bottomAnchor.constraint(equalTo: header.bottomAnchor),
            divider.leftAnchor.constraint(equalTo: header.leftAnchor),
            divider.rightAnchor.constraint(equalTo: header.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }
    

}
