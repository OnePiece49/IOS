//
//  LoginCollectionViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 06/03/2023.
//

import Foundation
import UIKit

class IntroCollectionViewCell: UICollectionViewCell {
    //MARK: - Properties
    static let identifier = "LoginCollectionViewCell"
    let infoImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()

    //MARK: - View LifeCycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        addSubview(infoImageView)
        infoImageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        infoImageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        infoImageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        infoImageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
}
