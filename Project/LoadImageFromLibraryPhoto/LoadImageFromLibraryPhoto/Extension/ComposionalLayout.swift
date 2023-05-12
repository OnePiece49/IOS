//
//  ComposionalLayout.swift
//  LoadImageFromLibraryPhoto
//
//  Created by Long Bảo on 02/05/2023.
//

import Foundation
import UIKit

enum ComposionalLayoutAxis {
    case horizontal
    case vertical
}

struct ComposionalLayout {
    static func createItem(layoutSize: NSCollectionLayoutSize) -> NSCollectionLayoutItem {
        let item = NSCollectionLayoutItem(layoutSize: layoutSize)
        return item
    }
    
    static func createGroup(axis: ComposionalLayoutAxis,
                            layoutSize: NSCollectionLayoutSize,
                            item: NSCollectionLayoutItem,
                            count: Int
    ) -> NSCollectionLayoutGroup {
        switch axis {
        case .horizontal:
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitem: item, count: count)
            return group
        case .vertical:
            let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitem: item, count: count)
            return group
        }
    }
    
    static func createGroup(axis: ComposionalLayoutAxis,
                            layoutSize: NSCollectionLayoutSize,
                            itemArray: [NSCollectionLayoutItem]
    ) -> NSCollectionLayoutGroup {
        switch axis {
        case .horizontal:
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: layoutSize, subitems: itemArray)
            return group
        case .vertical:
            let group = NSCollectionLayoutGroup.vertical(layoutSize: layoutSize, subitems: itemArray)
            return group
        }
    }
    
    static func createSection(group: NSCollectionLayoutGroup) -> NSCollectionLayoutSection {
        let section = NSCollectionLayoutSection(group: group)
//        section.interGroupSpacing = 12
        
//        let header = NSCollectionLayoutBoundarySupplementaryItem(layoutSize: NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(2 / 5)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
//        section.boundarySupplementaryItems = [header]
//        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 0)
        return section
    }
    
    
}

extension UIView {
    func setDimension(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            widthAnchor.constraint(equalToConstant: width),
            heightAnchor.constraint(equalToConstant: height),
        ])
        
    }
}
