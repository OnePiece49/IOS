//
//  FilmCollectionViewCell.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit
import SDWebImage


class FilmCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "FilmCollectionViewCell"
    
    public let posterImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.backgroundColor = .blue
        imageview.contentMode = .scaleAspectFill
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    
    //MARK: - View Liefcycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(posterImageView)
        posterImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        posterImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        posterImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        posterImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        
    }
    
    
    
    public func setImagePoster(urlImage: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(urlImage)") else {
            print("DEBUG: Failed")
            return}
        self.posterImageView.sd_setImage(with: url, completed: nil)
    }
}
