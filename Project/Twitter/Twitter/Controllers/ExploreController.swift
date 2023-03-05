//
//  ExploreController.swift
//  Twitter
//
//  Created by Long Bảo on 02/01/2023.
//

import UIKit

class ExploreController: UITableViewController {
    //MARK: - Properties
    private let userCell = "UserCell"
    private var users: [User]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var filterUser = [User]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    //MARK: - View LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()


        configureUI()
        configureSearchController()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = false //Khi quay trở về ko bị mất thanh navigationBar
        fetchUser()
    }
    
    //MARK: - Helpers
    func configureUI() {
        navigationItem.title = "Explores"
        let appearanceNav = UINavigationBarAppearance()
        appearanceNav.backgroundColor = .white
   
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black]
        self.navigationController?.navigationBar.compactAppearance = appearanceNav
        self.navigationController?.navigationBar.standardAppearance = appearanceNav
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearanceNav
        
        tableView.register(UserCell.self, forCellReuseIdentifier: userCell)
    }
    
    /// Có mấy cái hơi ảo
    func configureSearchController() {
        searchController.obscuresBackgroundDuringPresentation = false
        //SearchController.hidesNavigationBarDuringPresentation = false
        searchController.searchResultsUpdater = self
        searchController.searchBar.placeholder = "Search for a User"
        navigationItem.searchController = searchController
        definesPresentationContext = false
    }
    
    func fetchUser() {
        UserService.shared.fetchUsers { [weak self] users in
            self?.users = users
        }
    }
}

//MARK: - Delegate UITableViewDelegate and DataSource
extension ExploreController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.inSearchMode ? self.filterUser.count: users?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: userCell, for: indexPath) as! UserCell
        cell.layer.borderColor = .none
        cell.layer.borderWidth = 0
        guard let users = inSearchMode ? filterUser: users else {return cell}
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let users = inSearchMode ? filterUser: users else {return}
        let profileVC = ProfilelController(user: users[indexPath.row])
        navigationController?.pushViewController(profileVC, animated: true)
    }
}


//MARK: - UISearchResultsUpdating
extension ExploreController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let textSearch = searchController.searchBar.text?.lowercased() else {return}
        guard let users = users else {return}
        filterUser = users.filter({ user in
            user.userName.contains(textSearch)
        })
        
    }
    
    
}
