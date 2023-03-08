//
//  HomeTableViewCell.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit
import SDWebImage

protocol HomeTableViewCellDelegate: AnyObject {
    func didTapHomeTableViewCell(_: HomeTableViewCell)
    func didTapGetAllNewsButton()
}

class HomeTableViewCell: UITableViewCell {
    //MARK: - Properties
    weak var delegate: HomeTableViewCellDelegate?
    let header = HeaderHomeTableView()

    static let reuseIdentifier = "HomeTableViewCell"
    private let flowLayout = UICollectionViewFlowLayout()
    var collectionView: UICollectionView!
    var option: TitleSection? {
        didSet { self.configureHeader() }
    }
    var viewModel: HomeViewModel? {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    private let fakeView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.white
        return view
    }()
    
    //MARK: - View LifeCycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        //configureCollectionView()
    }
    
    //MARK: - Helpers
    func configureUI() {
        configureCollectionView()

    }
    
    
    func configureCollectionView() {
        addSubview(fakeView)
        fakeView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        fakeView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        fakeView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        fakeView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        configureHeader()
        flowLayout.minimumLineSpacing = 12
        flowLayout.scrollDirection = .horizontal
        backgroundColor  = UIColor(rgb: 0xFFFFFF)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        contentView.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        collectionView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        
        collectionView.register(HomeDoctorCollectionViewCell.self, forCellWithReuseIdentifier: HomeDoctorCollectionViewCell.reuseIdentifier)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: HomeCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsVerticalScrollIndicator = false
    }
    
    func configureHeader() {
        header.option = option
        contentView.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        guard let option = option else {
            return
        }
        if option == .articlesList {
            header.topAnchor.constraint(equalTo: topAnchor).isActive = true
        } else {
            header.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        }

        header.topAnchor.constraint(equalTo: topAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 52).isActive = true
        header.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        header.delegate = self
    }
    
    
    
    //MARK: - Selectors
}

//MARK: - Delegate Delegate/DataSourceCollectionView
extension HomeTableViewCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let option = option else {return 0}
        guard let viewModel = viewModel else {return 0}
        switch option {
        case .articlesList:
            return viewModel.numberArticle
        case .promotionList:
            return viewModel.numberPromotions
        case .doctorList:
            return viewModel.numberDoctors
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if option == .doctorList {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDoctorCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeDoctorCollectionViewCell
            guard let option = option else {return cell}
            guard var viewModel = viewModel else {return cell}
            viewModel.currentIndex = indexPath.row
            viewModel.option = option
            cell.userNameImage.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(named: "doctor 1 1"), options: .lowPriority, completed: .none)
            cell.reviewLabel.attributedText = viewModel.reviewTextAttributed
            cell.majorLabel.text = viewModel.majorDoctorString
            cell.userNameLabel.text = viewModel.userNameDoctorString
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        guard let option = option else {return cell}
        guard var viewModel = viewModel else {return cell}
        viewModel.currentIndex = indexPath.row
        viewModel.option = option
        cell.subTitleLabel.attributedText = viewModel.subTextAttributed
        cell.mainTitleLabel.attributedText = viewModel.mainTextAttributed
        cell.titleImage.sd_setImage(with: viewModel.imageURL, completed: .none)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let option = option else {return CGSize(width: 0, height: 0)}
        if option == .doctorList {return CGSize(width: 121, height: 185)}
        return CGSize(width: 258, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapHomeTableViewCell(self)
    }
}

extension HomeTableViewCell: HeaderHomeTableViewDelegate {
    func didTapGetAllNewsButton() {
        delegate?.didTapGetAllNewsButton()
    }
}
