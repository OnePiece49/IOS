//
//  NewsDetailController.swift
//  MedicalNews
//
//  Created by Long Bảo on 08/03/2023.
//

import Foundation
import UIKit

class NewsController: UIViewController {
    //MARK: - Properties
    let header = NewsHeaderView()
    let tableView = UITableView()
    var viewModel: NewsViewModel? {
        didSet {
            tableView.reloadData()
            updateHeader()
        }
    }

    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        configureHeaderView()
        configureTableView()
    }
    
    func configureHeaderView() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.setContentCompressionResistancePriority(UILayoutPriority(rawValue: 751), for: .vertical)
        header.delegate = self
    }
    
    func updateHeader() {
        guard let viewModel = viewModel else {
            return
        }

        header.headerImageView.sd_setImage(with: viewModel.imageTitleTURL, completed: .none)
        header.dateLabel.text = viewModel.dateTitleString
        header.mainNewsTitleLabel.text = viewModel.titleString
    }
    
    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12).isActive = true
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.reuseIdentifier)
    }
    
    //MARK: - Selectors
}

extension NewsController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.numberArticle ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.reuseIdentifier, for: indexPath) as! NewsTableViewCell
        cell.viewModel = viewModel
        cell.viewModel?.currentIndex = indexPath.row
        return cell
    }
}

extension NewsController: NewsHeaderControllerDelegate {
    func didBackButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
}
