//
//  CollectionViewCellTableViewCell.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit

protocol CollectionViewCellTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewCellTableViewCell, viewModel: FilmPreviewViewModel)
}

class CollectionViewCellTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "CollectionViewCellTableViewCell"
    weak var delegate: CollectionViewCellTableViewCellDelegate?
    
    var resultsAPICaller: [DataAPI]? {
        didSet {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            
        }
    }
    
    private let collectionView: UICollectionView = {
        let layout =  UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(FilmCollectionViewCell.self, forCellWithReuseIdentifier: FilmCollectionViewCell.identifier)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    //MARK: - View lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        contentView.backgroundColor = .systemGray
        addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}

//MARK: - Extension
extension CollectionViewCellTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultsAPICaller?.count ?? 0
    }
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilmCollectionViewCell.identifier, for: indexPath) as! FilmCollectionViewCell
        cell.backgroundColor = .green
        guard let urlImage = self.resultsAPICaller?[indexPath.row].poster_path else {return UICollectionViewCell()}
        cell.setImagePoster(urlImage: urlImage)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)

        guard let results = resultsAPICaller else {return}
        guard let title = results[indexPath.row].original_title else {return}
        guard let overview = results[indexPath.row].overview else {return}

        APICaller.shared.getMovieFromApiYoutobe(with: title + " trailer ") { [weak self] dataPreviewYoutobe in
            guard let strongSelf = self else {return}
            switch dataPreviewYoutobe {
            case .success(let data):
                let viewModel = FilmPreviewViewModel(title: title, youtobeView: data, titleOverview: overview)
                strongSelf.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
            case .failure(let error):
                print("DEBUG: \(error.localizedDescription)")
            }
        }
    }
    
}
