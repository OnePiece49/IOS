//
//  DoctorHeaderView.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit

protocol DoctorHeaderViewDelegate: AnyObject {
    func didTapBackButton()
}

class DoctorHeaderView: UIView {
    //MARK: - Properties
    weak var delegate: DoctorHeaderViewDelegate?
    
    private lazy var flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)

    private lazy var backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 32 / 2
        button.setImage(UIImage(named: "chevron-left"), for: .normal)
        button.addTarget(self, action: #selector(handleBackButtonTapped), for: .touchUpInside)
        button.backgroundColor = UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 0.3)
        button.backgroundColor = UIColor(rgb: 0xFFFFFF)
        return button
    }()
    
    private lazy var fakeView: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
     lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "NunitoSans-Bold", size: 20)
        label.textColor =  UIColor(red: 0.141, green: 0.165, blue: 0.38, alpha: 1)
        label.textAlignment = .left
        label.text = "Thông tin cá nhân"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [backButton, titleLabel, fakeView])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.distribution = .equalCentering
        stack.alignment = .center
        backButton.widthAnchor.constraint(equalToConstant: 32).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        return stack
    }()
    
    private let dividerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - View Lifecycle
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    func configureUI() {
        //addSubview(headerImageView)
        addSubview(titleStack)
        titleStack.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        titleStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        titleStack.heightAnchor.constraint(equalToConstant: 44).isActive = true
        
        addSubview(dividerView)
        dividerView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        dividerView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        dividerView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        dividerView.backgroundColor = UIColor(rgb: 0xEEEFF4)
        dividerView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
    }
    
    //MARK: - Selectors
    @objc func handleBackButtonTapped() {
        delegate?.didTapBackButton()
    }
}

