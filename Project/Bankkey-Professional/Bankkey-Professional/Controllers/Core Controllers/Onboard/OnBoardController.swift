//
//  OnBoardController.swift
//  Bankkey-Professional
//
//  Created by Long Bảo on 22/03/2023.
//

import Foundation
import UIKit

class OnboardController: UIViewController {
    //MARK: - Properties
    private let imageString: String
    private let titleString: String
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var titleImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    //MARK: - View Lifecycle
    init(imageString: String, titleString: String) {
        self.imageString = imageString
        self.titleString = titleString
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(titleImage)
        view.addSubview(titleLabel)
        
        titleImage.image = UIImage(named: imageString)
        titleImage.contentMode = .scaleAspectFit
        titleLabel.text = titleString
        
        let stack = UIStackView(arrangedSubviews: [titleImage, titleLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8),
            stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8),
        ])
    }
    
    //MARK: - Selectors
    deinit {
        print("DEBUG: Onboard Deinit")
    }
    
}
//MARK: - delegate
