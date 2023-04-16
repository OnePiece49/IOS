//
//  HomeViewModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

enum TitleSection: Int ,CaseIterable {
    case articlesList = 0
    case promotionList = 1
    case doctorList = 2
    
    var description: String {
        switch self {
        case .articlesList:
            return "Tin tức"
        case .promotionList:
            return "Khuyễn mãi"
        case .doctorList:
            return "Giới thiệu bác sĩ"
        }
    }
}

class HomeViewModel {
    private var homeModel: HomeModel! {
        didSet {
            self.binding()
        }
    }
    var option: TitleSection?

    var currentIndex: Int = 0
    var tempIndex: Int = 0
    var binding: (() -> Void) = {}
    
    func fetchData() {
        HomeSerVice.shared.fetchAllData { homeModel in
            self.homeModel = homeModel
        }
    }

    func getArticleList() -> [ArticleModel] {
        return homeModel.data.articleList
    }
    
    func getPromotionList() -> [PromotionModel] {
        return homeModel.data.promotionList
    }
    
    func getDoctorList() -> [DoctorModel] {
        return homeModel.data.doctorList
    }
    
    func getNumberNews(section: Int) -> Int {
        switch section {
        case 0:
            guard let homeModel = self.homeModel else {return 0}
            return homeModel.data.articleList.count
        case 1:
            guard let homeModel = self.homeModel else {return 0}
            return homeModel.data.promotionList.count
        case 2:
            guard let homeModel = self.homeModel else {return 0}
            return homeModel.data.doctorList.count
        default:
            return 0
        }
    }
    
    func getArticle(indexPath: IndexPath) -> ArticleModel {
        return homeModel.data.articleList[indexPath.row]
    }
    
    func getPromotion(indexPath: IndexPath) -> PromotionModel {
        return homeModel.data.promotionList[indexPath.row]
    }
    
    func getDoctor(indexPath: IndexPath) -> DoctorModel {
        return homeModel.data.doctorList[indexPath.row]
    }
    
    func getUrl(indexPath: IndexPath) -> URL? {
        if indexPath.section != 0 && indexPath.section != 1 {
            return nil
        }
        
        switch indexPath.section {
        case 0:
            return URL(string: getArticleList()[indexPath.row].link)
        case 1:
            return URL(string: getPromotionList()[indexPath.row].link)
        default:
            return nil
        }
    }

    
}
