//
//  SettingSexInfoTableView.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit


class SettingSexInfoTabelViewCell: UITableViewCell {
    //MARK: - Properties
    static let reuseIdentifier = "SettingSexInfoTabelViewCell"
    
    var viewModel: PromotionViewModel?
    
    private lazy var titleInputLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-SemiBold", size: 13)
        label.textColor =  UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)
        label.textAlignment = .left
        label.text = "Giới tính"
        label.numberOfLines = 0
        return label
    }()
    
    let segmentControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(with: UIImage(named: "Frame 45376"), at: 1, animated: true)
        segment.insertSegment(with: UIImage(named: "Frame 45377"), at: 2, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.selectedSegmentIndex = 0
        segment.setTitleTextAttributes([.foregroundColor: UIColor(red: 0.278, green: 0.29, blue: 0.341, alpha: 1)], for: .normal)
        segment.setTitleTextAttributes([.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)], for: .selected)
        return segment
    }()
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    //MARK: - Helpers
    func configureUI() {
        contentView.addSubview(titleInputLabel)
        titleInputLabel.topAnchor.constraint(equalTo: topAnchor, constant: 26).isActive = true
        titleInputLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        
        contentView.addSubview(segmentControl)
        segmentControl.topAnchor.constraint(equalTo: titleInputLabel.bottomAnchor, constant: 8).isActive = true
        segmentControl.leftAnchor.constraint(equalTo: titleInputLabel.leftAnchor).isActive = true
        segmentControl.rightAnchor.constraint(equalTo: rightAnchor, constant: -30).isActive = true
        segmentControl.heightAnchor.constraint(equalTo: segmentControl.widthAnchor, multiplier: 44 / 327).isActive = true
        
    }
    
    //MARK: - Selectors

}
