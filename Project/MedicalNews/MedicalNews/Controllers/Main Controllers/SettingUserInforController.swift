//
//  SettingUserInforController.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit

class SettingUserInforController: UIViewController {
    //MARK: - Properties
    let header = DoctorHeaderView()
    
    private  lazy var flowLayout = UICollectionViewFlowLayout()
    private lazy var tableView = UITableView()
    var viewModel = SettingUserInfoViewModel()
    var dataUser: InfoUser? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchData()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .blue
        configureHeader()
        configureTableView()
    }
    
    func configureHeader() {
        view.backgroundColor = .white
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 44).isActive = true
        header.delegate = self
    }

    func configureTableView() {
        view.addSubview(tableView)

        tableView.backgroundColor = .white
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.register(SettingSexInfoTabelViewCell.self, forCellReuseIdentifier: SettingSexInfoTabelViewCell.reuseIdentifier)
        tableView.register(SettingUserInfoTableViewCell.self, forCellReuseIdentifier: SettingUserInfoTableViewCell.reuseIdentifier)
        tableView.register(SettingDoneTableViewCell.self, forCellReuseIdentifier: SettingDoneTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
    }
    
    func fetchData() {
        viewModel.fetchNewData()
        viewModel.completion = { [weak self] isReciveData in
            if isReciveData {
                self?.dataUser = self?.viewModel.data
            }
            
        }
    }
    
    //MARK: - Selectors
}

extension SettingUserInforController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SettingOption.allCases.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 3 {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingSexInfoTabelViewCell.reuseIdentifier, for: indexPath) as! SettingSexInfoTabelViewCell
                return cell
        } else if indexPath.row == SettingOption.allCases.count {
            let cell = tableView.dequeueReusableCell(withIdentifier: SettingDoneTableViewCell.reuseIdentifier, for: indexPath) as! SettingDoneTableViewCell
                return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingUserInfoTableViewCell.reuseIdentifier, for: indexPath) as! SettingUserInfoTableViewCell
        cell.viewModel = SettingUserInfoCellViewModel(option: SettingOption(rawValue: indexPath.row) ?? .name, user: dataUser)
        SettingUserInfoService.shared.fetchLocationUser(user: dataUser) { location in
            cell.viewModel?.location = location
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "FetchDoneLocationUser"), object: .none, userInfo: .none)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 3 {return 103}
        if indexPath.row == SettingOption.allCases.count {return view.frame.width * 134 / 327}
        return 79
    }
    
}

extension SettingUserInforController: DoctorHeaderViewDelegate {
    func didTapBackButton() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
