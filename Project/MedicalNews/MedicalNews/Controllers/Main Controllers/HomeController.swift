//
//  HomeController.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

class HomeController: UIViewController {
    //MARK: - Properties
    private let header = HeaderHomeView()
    private let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var viewModel: HomeViewModel = HomeViewModel()
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        self.viewModel.binding = {
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
        self.fetchData()
    }
    
    //MARK: - Helpers
    func configureUI() {
        view.addSubview(header)
        view.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.1).cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowRadius = 10
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: header.widthAnchor, multiplier: 143 / 375).isActive = true
        header.delegate = self
        configureCollectionView()
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: header.bottomAnchor, constant: -16).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        collectionView.layer.cornerRadius = 16

        //collectionView.isExclusiveTouch = false
        collectionView.register(NewsAndPromotionCollectionViewCell.self, forCellWithReuseIdentifier: NewsAndPromotionCollectionViewCell.reuseIdentifier)
        collectionView.register(HomeDoctorCollectionViewCell.self, forCellWithReuseIdentifier: HomeDoctorCollectionViewCell.reuseIdentifier)
        collectionView.register(HeaderHomeCollectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderHomeCollectionView.identifier)
        collectionView.collectionViewLayout = createLayout()
    }
    

    func createLayout() -> UICollectionViewLayout {
        func createSectionDoctor() -> NSCollectionLayoutSection {
            let item = ComposionalLayout.createItem(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            //item.edgeSpacing =
            let group = ComposionalLayout.createGroup(axis: .horizontal, layoutSize: NSCollectionLayoutSize.init(widthDimension: .absolute(121), heightDimension: .absolute(185)), itemArray: [item])
            
            let section = ComposionalLayout.createSection(group: group)
            return section
        }
        
        func createSectionNewsAndPromotion() -> NSCollectionLayoutSection {
            let item = ComposionalLayout.createItem(layoutSize: NSCollectionLayoutSize.init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)))
            let group = ComposionalLayout.createGroup(axis: .horizontal, layoutSize: NSCollectionLayoutSize.init(widthDimension: .absolute(258), heightDimension: .absolute(220)), itemArray: [item])
            
            let section = ComposionalLayout.createSection(group: group)
            return section
        }
        
        let layout = UICollectionViewCompositionalLayout { section, env -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let section = createSectionNewsAndPromotion()
                return section
            case 1:
                let section = createSectionNewsAndPromotion()
                return section
            default:
                let section = createSectionDoctor()
                return section
            }
        }
        
        return layout
    }
    
    private func fetchData() {
        viewModel.fetchData()
    }
    
    //MARK: - Selectors
}

//MARK: - Delegate Datasource/DelegateTableViewController
extension HomeController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsAndPromotionCollectionViewCell.reuseIdentifier, for: indexPath) as! NewsAndPromotionCollectionViewCell
            cell.option =  .articlesList
            let article = self.viewModel.getArticle(indexPath: indexPath)
            cell.viewModel = HomeCollectionViewCellModel(option: .articlesList, articleModel: article)
            return cell
        } else if indexPath.section == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsAndPromotionCollectionViewCell.reuseIdentifier, for: indexPath) as! NewsAndPromotionCollectionViewCell
            cell.option = .promotionList
            let promotion = self.viewModel.getPromotion(indexPath: indexPath)
            cell.viewModel = HomeCollectionViewCellModel(option: .promotionList, promotionModel: promotion)
            
            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeDoctorCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeDoctorCollectionViewCell
            cell.option = TitleSection(rawValue: 2) ?? .doctorList
            let doctor = self.viewModel.getDoctor(indexPath: indexPath)
            cell.viewModel = HomeCollectionViewCellModel(option: .doctorList, doctorModel: doctor)

            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getNumberNews(section: section) 
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderHomeCollectionView.identifier, for: indexPath) as! HeaderHomeCollectionView
        header.option = TitleSection(rawValue: indexPath.section) ?? .articlesList
        header.delegate = self
        return header
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 2 {
            return
        }
        
        let detailController = NewsDetailController()
        detailController.newsURL = viewModel.getUrl(indexPath: indexPath)
        self.navigationController?.pushViewController(detailController, animated: true)
    }
}


extension HomeController: HeaderHomeViewDelegate {
    func didTapAvatarImage() {
        self.navigationController?.pushViewController(SettingUserInforController(), animated: true)
    }
}

extension HomeController: HeaderHomeTableViewDelegate {
    func didTapGetAllNewsButton(option: TitleSection) {
        switch option {
        case .articlesList:
            let newsController = NewsController()
            newsController.viewModel = NewsViewModel(articles: viewModel.getArticleList())
            self.navigationController?.pushViewController(newsController, animated: true)
        case .promotionList:
            let promotionController = PromotionController()
            promotionController.viewModel = PromotionViewModel(promotions: viewModel.getPromotionList())
            self.navigationController?.pushViewController(promotionController, animated: true)
        case .doctorList:
            let doctorController = DoctorsController()
            doctorController.viewModel = DoctorViewModel(doctorList: viewModel.getDoctorList())
            self.navigationController?.pushViewController(doctorController, animated: true)
        }

    }
    
    
}



