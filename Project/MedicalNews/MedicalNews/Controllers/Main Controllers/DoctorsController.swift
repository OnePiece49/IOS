//
//  DoctorsController.swift
//  MedicalNews
//
//  Created by Long Bảo on 08/03/2023.
//

import Foundation
import UIKit

class DoctorsController: UIViewController {
    //MARK: - Properties
    let header = DoctorHeaderView()
    private  lazy var flowLayout = UICollectionViewFlowLayout()
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
    var viewModel: DoctorViewModel? {
        didSet {collectionView.reloadData()}
    }
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        configureHeader()
        configureCollectionView()
    }
    
    func configureHeader() {
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 44).isActive = true
        header.titleLabel.text = "Bác sĩ"
        header.delegate = self
    }
    
    func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 12).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.register(DoctorCollectionViewCell.self, forCellWithReuseIdentifier: DoctorCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    //MARK: - Selectors
}

extension DoctorsController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel?.numberDoctor ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorCollectionViewCell.reuseIdentifier, for: indexPath) as! DoctorCollectionViewCell
        cell.viewModel = viewModel
        cell.viewModel?.currentIndex = indexPath.row
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 24, height: 105)
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 11
//    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
}

extension DoctorsController: DoctorHeaderViewDelegate {
    func didTapBackButton() {
        navigationController?.popViewController(animated: true)
    }
    
}
