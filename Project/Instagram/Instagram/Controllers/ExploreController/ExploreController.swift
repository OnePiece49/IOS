//
//  SearchController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

class ExploreController: UIViewController {
    //MARK: - Properties
    let viewModel = ExploreViewModel()
    let searchBar = CustomSearchBarView(frame: .zero)
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let searchTableView = UITableView(frame: .zero, style: .plain)
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureProperties()
        fetchOtherUsers()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(collectionView)
        view.addSubview(searchTableView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchTableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchBar.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 6),
            searchBar.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 36),
            
            collectionView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchTableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            searchTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            searchTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    
    }

    
    func configureProperties() {
        searchBar.delegate = self
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.collectionViewLayout = self.createLayoutCollectionView()
        collectionView.register(ExploreCollectionViewCell.self,
                                forCellWithReuseIdentifier: ExploreCollectionViewCell.identifier)
        
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.register(ExploreSearchBarTableViewCell.self,
                                 forCellReuseIdentifier: ExploreSearchBarTableViewCell.identifier)
        searchTableView.alpha = 0
        searchTableView.backgroundColor = .systemBackground
        searchTableView.separatorColor = .clear
    }
    
    func createLayoutCollectionView() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1 / 3),
                                              heightDimension: .fractionalHeight(1.0))
        let item = ComposionalLayout.createItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalWidth(1 / 3 ))
        let group = ComposionalLayout.createGroup(axis: .horizontal,
                                                  layoutSize: groupSize,
                                                  item: item,
                                                  count: 3)
        group.interItemSpacing = .fixed(1)
        
        let section = ComposionalLayout.createSectionWithouHeader(group: group)
        section.interGroupSpacing = 1
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
    
    func fetchOtherUsers() {
        viewModel.fetchOtherUsers()
    }
    
    //MARK: - Selectors

    
}
//MARK: - delegate
extension ExploreController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExploreCollectionViewCell.identifier,
                                                      for: indexPath) as! ExploreCollectionViewCell
        cell.backgroundColor = .red
        
        return cell
    }
}

extension ExploreController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberUserFounded
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ExploreSearchBarTableViewCell.identifier,
                                                 for: indexPath) as! ExploreSearchBarTableViewCell
        cell.user = viewModel.userAtIndexPath(indexPath: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}

extension ExploreController: CustomSearchBarDelegate {
    func didChangedSearchTextFiled(textField: UITextField) {
        guard let name = textField.text else {return}
        viewModel.searchUsers(name: name)
        searchTableView.reloadData()
    }
    
    func didBeginEdittingSearchField(textField: UITextField) {
        UIView.animate(withDuration: 0.25) {
            self.searchTableView.alpha = 1
        }

    }
    
    func didSelectCancelButton() {
        UIView.animate(withDuration: 0.25) {
            self.searchTableView.alpha = 0
        }
    }
    
}
