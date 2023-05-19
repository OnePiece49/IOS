//
//  EditProfileTableViewCell.swift
//  Instagram
//
//  Created by Long Bảo on 18/05/2023.
//

import UIKit

enum EditProfileCellType: Int, CaseIterable {
    case fullname
    case username
    case bio
    case link
    
    var description: String {
        switch self {
        case .fullname:
            return "Fullname"
        case .username:
            return "Username"
        case .bio:
            return "Bio"
        case .link:
            return "Link"
        }
    }
}

class EditProfileCell {
    private var type: EditProfileCellType
    private var data: String? = nil
    
    var mainTitle: String? {
        guard let data = data else {
            switch type {
            case .bio:
                return "Bio"
            case .link:
                return "Add link"
            default:
                return ""
            }
        }
        
        return data
    }
    
    var subTitle: String? {
        return type.description
    }
    
    init(type: EditProfileCellType, data: String? = nil) {
        self.type = type
        self.data = data
    }
}

class EditProfileTableViewCell: UITableViewCell {
    //MARK: - Properties
    static let identifier = "EditProfileTableViewCell"
    var cellData: EditProfileCell? {
        didSet {
            self.updateUI()
        }
    }
    
    private lazy var subLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .black
        return label
    }()
    
    
    private let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray
        return view
    }()
    
    //MARK: - View Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configureUI() {
        self.activeConstraint()
    }
    
    func activeConstraint() {
        addSubview(subLabel)
        addSubview(mainLabel)
        addSubview(divider)
        
        NSLayoutConstraint.activate([
            subLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            subLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 12),
            subLabel.widthAnchor.constraint(equalToConstant: 85),
            
            mainLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12),
            mainLabel.leftAnchor.constraint(equalTo: subLabel.rightAnchor, constant: 2),
            mainLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -15),
            
            divider.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 12),
            divider.leftAnchor.constraint(equalTo: subLabel.rightAnchor),
            divider.rightAnchor.constraint(equalTo: mainLabel.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    //MARK: - Selectors
    func updateUI() {
        guard let cellData = cellData else {
            return
        }
        
        if cellData.mainTitle == "Bio" || cellData.mainTitle == "Add link" {
            self.mainLabel.textColor = .systemGray
        }
        self.mainLabel.text = cellData.mainTitle
        self.subLabel.text = cellData.subTitle
    }
    
}
//MARK: - delegate

