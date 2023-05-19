//
//  SelectedSettingProfileController.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit


class SelectedSettingProfileController: UIViewController {
    //MARK: - Properties
    let tableView = UITableView(frame: .zero, style: .plain)
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    private let scrollDivider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        view.setDimensions(width: 36, height: 4)
        view.clipsToBounds = true
        view.layer.cornerRadius = 2
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
        view.backgroundColor = .white
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.isScrollEnabled = false
        tableView.register(SelectedTypeTableViewCell.self,
                           forCellReuseIdentifier: SelectedTypeTableViewCell.identifier)
        
        
        activeConstraint()
    }
    
    func activeConstraint() {
        view.addSubview(tableView)
        view.addSubview(scrollDivider)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            scrollDivider.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            scrollDivider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: scrollDivider.bottomAnchor, constant: 9),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension SelectedSettingProfileController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SelectedSettingProfileType.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SelectedTypeTableViewCell.identifier, for: indexPath) as! SelectedTypeTableViewCell
        cell.dataTypeSettingProfile = SelectedSettingProfileType(rawValue: indexPath.row)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 48
    }

    


}
