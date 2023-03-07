//
//  HomeController.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    //MARK: - Properties
    private let header = HeaderHomeView()
    private let tableView = UITableView()
    
    //MARK: - View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: header.widthAnchor, multiplier: 143 / 375).isActive = true
        configureTableView()
    }
    
    func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HomeTableViewCell.self, forCellReuseIdentifier: HomeTableViewCell.reuseIdentifier)
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -16).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.layer.cornerRadius = 16
        tableView.separatorStyle = .none
    }
    
    //MARK: - Selectors
}

//MARK: - Delegate Datasource/DelegateTableViewController
extension HomeController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.reuseIdentifier, for: indexPath) as! HomeTableViewCell
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = HeaderHomeTableView()
        header.heightAnchor.constraint(equalToConstant: 65).isActive = true
        header.option = TitleSection(rawValue: section)
        return header
    }
    
}
