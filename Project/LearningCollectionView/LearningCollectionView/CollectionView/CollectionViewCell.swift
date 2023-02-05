//
//  CollectionViewCell.swift
//  LearningCollectionView
//
//  Created by Long Bảo on 20/01/2023.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .red
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
