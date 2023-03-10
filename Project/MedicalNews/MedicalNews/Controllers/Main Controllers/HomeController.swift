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
    private var viewModel: HomeViewModel? {
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
        view.addSubview(header)
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: header.widthAnchor, multiplier: 143 / 375).isActive = true
        header.delegate = self
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
        tableView.isExclusiveTouch = false
    }
    
    func fetchData() {
        HomeSerVice.shared.fetchAllData { homeModel in
            self.viewModel = HomeViewModel(homeModel: homeModel)
        }
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
        cell.option = TitleSection(rawValue: indexPath.section)
        cell.viewModel = viewModel
        cell.delegate = self
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 251
        }
        return 284
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension HomeController: HomeTableViewCellDelegate {
    func didTapGetAllNewsButton(_ cell: HomeTableViewCell) {
        guard let option = cell.option else {return}
            switch option {
            case .articlesList:
                let newsController = NewsController()
                guard let viewModel = viewModel else {return}
                newsController.viewModel = NewsViewModel(articles: viewModel.articles)
                navigationController?.pushViewController(newsController, animated: true)
            case .promotionList:
                let promotionVC = PromotionController()
                guard let promotions = viewModel?.promotions else {return}
                promotionVC.viewModel = PromotionViewModel(promotions: promotions)
                navigationController?.pushViewController(promotionVC, animated: true)
            case .doctorList:
                let doctorVC = DoctorsController()
                guard let doctors = viewModel?.doctors else {return}
                doctorVC.viewModel = DoctorViewModel(doctorList: doctors)
                navigationController?.pushViewController(doctorVC, animated: true)
            }
        }
    
    func didTapCollectionViewCell(_ cell: HomeTableViewCell, indexPath: IndexPath) {
        guard let option = cell.option else {return}
        switch option {
        case .articlesList:
            let newdetailsVC = NewsDetailController()
            navigationController?.pushViewController(newdetailsVC, animated: true)
            newdetailsVC.newsURL = cell.viewModel?.getLinkArticle(index: indexPath.row)
        case .promotionList:
            let promotionVC = PromotionController()
            guard let promotions = viewModel?.promotions else {return}
            promotionVC.viewModel = PromotionViewModel(promotions: promotions)
            navigationController?.pushViewController(promotionVC, animated: true)
        case .doctorList:
            let doctorVC = DoctorsController()
            guard let doctors = viewModel?.doctors else {return}
            doctorVC.viewModel = DoctorViewModel(doctorList: doctors)
            navigationController?.pushViewController(doctorVC, animated: true)
        }
    }
}

extension HomeController: HeaderHomeViewDelegate {
    func didTapAvatarImage() {
        self.navigationController?.pushViewController(SettingUserInforController(), animated: true)
    }
    
    
}



