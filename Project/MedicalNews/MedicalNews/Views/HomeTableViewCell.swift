//
//  HomeTableViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HomeTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "HomeTableViewCell"
    
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    //MARK: - Selectors
}
