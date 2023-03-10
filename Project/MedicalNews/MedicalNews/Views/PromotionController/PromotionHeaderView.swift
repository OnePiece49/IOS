//
//  PromotionHeaderView.swift
//  MedicalNews
//
//  Created by Long Bảo on 09/03/2023.
//

import Foundation
import UIKit

protocol PromotionHeadViewDelegate: AnyObject {
    func didTapBackButton()
}

class PromotionHeadView: UIView {
    //MARK: - Properties
    weak var delegate: PromotionHeadViewDelegate?
    
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
        label.text = "Danh sách khuyễn mãi"
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
        
        configureCollectionView()
    }
    
    
    func configureCollectionView() {
        addSubview(collectionView)
        flowLayout.scrollDirection = .horizontal
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(PromotionCollectionHeaderCell.self, forCellWithReuseIdentifier: PromotionCollectionHeaderCell.reuseIdentifier)
        collectionView.topAnchor.constraint(equalTo: titleStack.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 64).isActive = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = false
    }

    
    //MARK: - Selectors
    @objc func handleBackButtonTapped() {
        delegate?.didTapBackButton()
    }
}

extension PromotionHeadView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PromotionCollectionHeaderCell.reuseIdentifier, for: indexPath) as! PromotionCollectionHeaderCell
        cell.option = PromotionOption(rawValue: indexPath.row)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: frame.width / 2  , height: 64)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return -2
    }
}
