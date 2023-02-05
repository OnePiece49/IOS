//
//  SearchResultViewController.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 04/02/2023.
//

import UIKit

protocol SearchResultViewControllerDelegate {
    func didSeclectCollectionViewCellTapped(model: FilmPreviewViewModel)
}

class SearchResultViewController: UIViewController {
    
    //MARK: - Properties
    public var delegate: SearchResultViewControllerDelegate?
    
    public var searchResult: [DataAPI]? {
        didSet {
            DispatchQueue.main.async {
                self.searchResultsCollectionView.reloadData()
            }
        }
    }
    
    public let searchResultsCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        flowLayout.minimumLineSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        return collectionView
    }()
    
    //MARK: - View Lifecyle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        view.addSubview(searchResultsCollectionView)
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        print("DEBUG: 1")
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
        print("DEBUG: 2")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG: 3")
    }

    //MARK: - Heplers
    func configureUI() {
        view.backgroundColor = .red
    }

}


//MARK: - Extensions
extension SearchResultViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return searchResult?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
        guard let urlImageString = searchResult?[indexPath.row].poster_path else {return cell}
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w500\(urlImageString)") else {
            return cell
        }
        
        cell.posterImageView.sd_setImage(with: urlImage, completed: .none)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        guard let results = searchResult else {return}
        guard let title = results[indexPath.row].original_title else {return}
        guard let overview = results[indexPath.row].overview else {return}
        
        APICaller.shared.getMovieFromApiYoutobe(with: title + " trailer ") { [weak self] dataPreviewYoutobe in
            guard let strongSelf = self else {return}
            switch dataPreviewYoutobe {
            case .success(let data):
                let viewModel = FilmPreviewViewModel(title: title, youtobeView: data, titleOverview: overview)
                if self?.navigationController == nil { ///Just for check if this viewController has navigationColler
                    print("DEBUG: navigationCOntroller == nil in SearchResult")
                }
                strongSelf.delegate?.didSeclectCollectionViewCellTapped(model: viewModel)
            case .failure(let error):
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
}
