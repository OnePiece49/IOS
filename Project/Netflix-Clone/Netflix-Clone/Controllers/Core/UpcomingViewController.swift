//
//  UpcomingViewController.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit
import SDWebImage

class UpcomingViewController: UIViewController {
    //MARK: - Properties
    private var upcomingFilm : [DataAPI]? {
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
    

    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .red
        title = "Coming Soon"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(tableView)
        tableView.frame = view.bounds
        tableView.delegate = self
        tableView.dataSource = self
        
        fetchUpcomingFilm()
    }
    
    func fetchUpcomingFilm() {
        APICaller.shared.getUpcomingFilms { result in
            switch result{
            case .success(let data):
                self.upcomingFilm = data
            case .failure(let error):
                print("DEBUG: 1233>>>>>>.")
                print(error)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FilmTableViewCell.identifier, for: indexPath) as! FilmTableViewCell
        guard let titleFilm = upcomingFilm?[indexPath.row].original_title else {return cell}
        guard let urlImageString = upcomingFilm?[indexPath.row].poster_path else {return cell}
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w500\(urlImageString)") else {
            return cell
        }
        
        cell.posterImageView.sd_setImage(with: urlImage, completed: .none)
        cell.titleLabel.text = titleFilm
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return upcomingFilm?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let results = upcomingFilm else {return}
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
