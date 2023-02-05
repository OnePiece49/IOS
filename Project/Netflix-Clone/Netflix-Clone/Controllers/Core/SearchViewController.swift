//
//  HomeControllerViewController.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit

class SearchViewController: UIViewController {
    //MARK: - Properties
    private var discoveryMovies : [DataAPI]? {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(FilmTableViewCell.self, forCellReuseIdentifier: FilmTableViewCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return tableView
    }()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    /// Đoạn này hơi ảo
    private let searchController: UISearchController = {
        let searchResultVC = SearchResultViewController()
        let searchController = UISearchController(searchResultsController: searchResultVC)
        searchController.searchBar.placeholder = "Search for a Movie or a Tv show"
        searchController.searchBar.searchBarStyle = .minimal
        return searchController
    }()
    

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .red
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController                      //Chú ý
        searchController.searchResultsUpdater = self                            // Ảo
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        fetDiscoveryMovies()
    }
    
    func fetDiscoveryMovies() {
        APICaller.shared.getDiscoveryMovies { result in
            switch result{
            case .success(let data):
                self.discoveryMovies = data
            case .failure(let error):
                print("DEBUG: 1233>>>>>>.")
                print(error)
            }
        }
    }
}


//MARK: - Delegate UITableViewDelegate, UITableViewDataSource
extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as! FilmTableViewCell
        guard let titleFilm = discoveryMovies?[indexPath.row].original_title else {return cell}
        guard let urlImageString = discoveryMovies?[indexPath.row].poster_path else {return cell}
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w500\(urlImageString)") else {
            return cell
        }
        
        cell.posterImageView.sd_setImage(with: urlImage, completed: .none)
        cell.titleLabel.text = titleFilm
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return discoveryMovies?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let results = discoveryMovies else {return}
        guard let title = results[indexPath.row].original_title else {return}
        guard let overview = results[indexPath.row].overview else {return}
        
        APICaller.shared.getMovieFromApiYoutobe(with: title + " trailer ") { [weak self] dataPreviewYoutobe in
            DispatchQueue.main.async {
                guard let strongSelf = self else {return}
                
                switch dataPreviewYoutobe {
                case .success(let data):
                    let viewModel = FilmPreviewViewModel(title: title, youtobeView: data, titleOverview: overview)
                    let trailerVC = TrailerPreviewController()
                    trailerVC.updateSubView(with: viewModel)
                    strongSelf.navigationController?.pushViewController(trailerVC, animated: true)
                case .failure(let error):
                    print("DEBUG: \(error.localizedDescription)")
                }
            }
        }
    
    }
     
}

//MARK: - Delegate UISearchResultsUpdating
extension SearchViewController: UISearchResultsUpdating  {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        
        guard let query = searchBar.text,
                !query.trimmingCharacters(in: .whitespaces).isEmpty,
                query.trimmingCharacters(in: .whitespaces).count > 3,
              
              let resultsController = searchController.searchResultsController as? SearchResultViewController else {return}
        resultsController.delegate = self
        
        APICaller.shared.search(query: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    resultsController.searchResult = data
                case .failure(let error):
                    print(error)
                }
            }
        }
    }

}

//MARK: - Delegate SearchResultViewControllerDelegate
extension SearchViewController: SearchResultViewControllerDelegate {
    func didSeclectCollectionViewCellTapped(model: FilmPreviewViewModel) {
        DispatchQueue.main.async {
            let trailerVc = TrailerPreviewController()
            trailerVc.updateSubView(with: model)
            self.navigationController?.pushViewController(trailerVc, animated: true)
        }
    }
    
}

