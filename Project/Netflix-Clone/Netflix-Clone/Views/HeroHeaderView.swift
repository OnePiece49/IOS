//
//  HeroHeaderView.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import UIKit
import SDWebImage

class HeroHeaderView: UIView {
    
    //MARK: - Properties
    private let heroImageView: UIImageView = {
        let imageview = UIImageView(image: UIImage(named: "heroOnepiece"))
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        imageview.translatesAutoresizingMaskIntoConstraints = false
        return imageview
    }()
    
    private let playButton: UIButton = {
       let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let downloadButton: UIButton = {
       let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.borderColor = UIColor.systemBackground.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Hepers
    func configureUI() {
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstrain()
        
    }
    
    /// Một cách Constrain khác nhìn chuyên nghiệp hơn :)))
    private func applyConstrain() {
        let heroImageViewConstrain = [
            heroImageView.topAnchor.constraint(equalTo: topAnchor),
            heroImageView.leftAnchor.constraint(equalTo: leftAnchor),
            heroImageView.rightAnchor.constraint(equalTo: rightAnchor),
            heroImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ]
        
        let playButtonConstrain = [
            playButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 60),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -60),
            playButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let downloadButtonConstrain = [
            downloadButton.firstBaselineAnchor.constraint(equalTo: playButton.firstBaselineAnchor),
            downloadButton.rightAnchor.constraint(equalTo: rightAnchor , constant: -60),
            downloadButton.widthAnchor.constraint(equalTo: playButton.widthAnchor)
        ]

        NSLayoutConstraint.activate(heroImageViewConstrain)
        NSLayoutConstraint.activate(playButtonConstrain)
        NSLayoutConstraint.activate(downloadButtonConstrain)
    }
    
    /// Cái này làm mờ cái khung frame nó chứa hay sao ý :)) Not sure
    private func addGradient() {
        let gradient = CAGradientLayer()
        gradient.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradient.frame = bounds
        layer.addSublayer(gradient)
    }
    
    public func configureHeaderView(with model: DataAPI) {
        guard let urlImageString = model.poster_path else {return}
        guard let urlImage = URL(string: "https://image.tmdb.org/t/p/w500\(urlImageString)") else {return}
        heroImageView.sd_setImage(with: urlImage, completed: .none)
    }
}
