//
//  ReactionUsersController.swift
//  Instagram
//
//  Created by Long Bảo on 28/05/2023.
//

import UIKit

class UsersLikedController: UIViewController {
    //MARK: - Properties
    let viewModel: UserLikedViewModel
    let tableView = UITableView(frame: .zero, style: .plain)
    var navigationbar: NavigationCustomView!
    let searchBar = CustomSearchBarView(ishiddenCancelButton: true)

    //MARK: - View Lifecycle
    init(status: InstaStatus) {
        self.viewModel = UserLikedViewModel(status: status)
        super.init(nibName: nil, bundle: nil)
        self.fetchData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureProperties()
    }
    
    
    
    //MARK: - Helpers
    func fetchData() {
        viewModel.fetchData()
        viewModel.completion = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func configureUI() {
        self.setupNavigationBar()
        self.view.addSubview(navigationbar)
        self.view.addSubview(tableView)
        self.view.addSubview(searchBar)
        navigationbar.translatesAutoresizingMaskIntoConstraints = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.backgroundColor = .systemBackground
        view.backgroundColor = .systemBackground
        
        NSLayoutConstraint.activate([
            navigationbar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            navigationbar.leftAnchor.constraint(equalTo: view.leftAnchor),
            navigationbar.rightAnchor.constraint(equalTo: view.rightAnchor),
            navigationbar.heightAnchor.constraint(equalToConstant: 45),
            
            searchBar.topAnchor.constraint(equalTo: navigationbar.bottomAnchor, constant: 10),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 6),
            tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureProperties() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UserLikedTableViewCell.self,
                                 forCellReuseIdentifier: UserLikedTableViewCell.identifier)
        tableView.separatorStyle = .none
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "arrow-left"),
                                                       sizeImage: CGSize(width: 26, height: 26)) { [weak self] in
            self?.navigationController?.popViewController(animated: true)
        }
                                                   
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "share"),
                                                        sizeImage: CGSize(width: 28, height: 28))
                                                   
        self.navigationbar = NavigationCustomView(centerTitle: "Number Likes",
                                              attributeLeftButtons: [attributeFirstLeftButton],
                                              attributeRightBarButtons: [attributeFirstRightButton],
                                              beginSpaceLeftButton: 15,
                                              beginSpaceRightButton: 15)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
extension UsersLikedController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberUsers
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: UserLikedTableViewCell.identifier,
                                                 for: indexPath) as! UserLikedTableViewCell
        cell.viewModel = UserLikedCellViewModel(user: viewModel.userAtIndexPath(indexPath: indexPath))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 66
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let profileVc = ProfileController(user: viewModel.userAtIndexPath(indexPath: indexPath), type: .other)
        navigationController?.pushViewController(profileVc, animated: true)
    }
}
