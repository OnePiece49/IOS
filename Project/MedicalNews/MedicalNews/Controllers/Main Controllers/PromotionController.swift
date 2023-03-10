//
//  PromotionController.swift
//  MedicalNews
//
//  Created by Long Bảo on 08/03/2023.
//

import Foundation
import UIKit

class PromotionController: UIViewController {
    //MARK: - Properties
    let header = PromotionHeadView()
    let tableView = UITableView()
    var viewModel: PromotionViewModel? {
        didSet {tableView.reloadData()}
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureHeader()
        configureTableView()
    }
    
    func configureHeader() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 109).isActive = true
        header.delegate = self
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.backgroundColor = UIColor(red: 0.898, green: 0.898, blue: 0.898, alpha: 1)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -53.7).isActive = true
        tableView.register(PromotionTableViewCell.self, forCellReuseIdentifier: PromotionTableViewCell.reuseIdentifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
    }
    
    //MARK: - Selectors
}

extension PromotionController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PromotionTableViewCell.reuseIdentifier, for: indexPath) as! PromotionTableViewCell
        cell.viewModel = viewModel
        cell.viewModel?.currentIndex = indexPath.row
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberPromotion ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 102
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
}

extension PromotionController: PromotionTableViewCellDelegate {
    func didTapSaveButton(_ cell: PromotionTableViewCell) {
        cell.saveButton.setImage(UIImage(named: "bookmark-1"), for: .normal)
    }
}

extension PromotionController: PromotionHeadViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
    
}
