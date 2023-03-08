//
//  HomeViewModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation
import UIKit

enum TitleSection: Int {
    case articlesList
    case promotionList
    case doctorList
    
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

struct HomeViewModel {
    var articles: [ArticleList]
    let promotions: [PromotionList]
    var doctors: [DoctorList]
    var option: TitleSection?

    var currentIndex: Int = 0
    
    var numberSectionTable: Int {
        return 3
    }
    
    var numberArticle: Int {
        return articles.count
    }
    
    var numberPromotions: Int {
        return promotions.count
    }
    
    var numberDoctors: Int {
        return doctors.count
    }
    
    
    var mainTextAttributed: NSAttributedString {
        guard let option = option else {
            return NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        }

        switch option {
        case .articlesList:
            let textAttributed = NSMutableAttributedString(string: self.articles[currentIndex].title, attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 17)])
            return textAttributed
        case .promotionList:
            let textAttributed = NSMutableAttributedString(string: self.promotions[currentIndex].name, attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 17)])
            return textAttributed
        case .doctorList:
            return NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        }
    }
    
    var subTextAttributed: NSAttributedString {
        guard let option = option else {
            return NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        }

        switch option {
        case .articlesList:
            let textAttributed = NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
            textAttributed.append(NSAttributedString(string: " • ", attributes: [ NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.851, green: 0.859, blue: 0.882, alpha: 1)]))
            textAttributed.append(NSAttributedString(string: self.articles[currentIndex].created_at, attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)]))
            return textAttributed
            
        case .promotionList:
            let textAttributed = NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
            textAttributed.append(NSAttributedString(string: " • ", attributes: [ NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.851, green: 0.859, blue: 0.882, alpha: 1)]))
            textAttributed.append(NSAttributedString(string: self.articles[currentIndex].created_at, attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)]))
            return textAttributed
        case .doctorList:
            return NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        }
    }
    
    var userNameDoctorString: String {
        if option == .doctorList {
            return doctors[currentIndex].full_name
        } else {
            return ""
        }
    }
    
    var majorDoctorString: String {
        if option == .doctorList {
            return doctors[currentIndex].majors_name
        } else {
            return ""
        }
    }
    
    var reviewTextAttributed: NSAttributedString {
        if option == .doctorList {
            let textAttributed = NSMutableAttributedString(string: "\(doctors[currentIndex].ratio_star)", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.278, green: 0.29, blue: 0.341, alpha: 1)])
            textAttributed.append(NSAttributedString(string: "(\(doctors[currentIndex].number_of_reviews))", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 17)]))
            return textAttributed
        } else {
            return NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
        }
    }
    
    var imageURL: URL? {
        guard let option = option else {
            return nil
        }
        
        switch option {
        case .articlesList:
            return URL(string: self.articles[currentIndex].picture)
        case .promotionList:
            return URL(string: self.promotions[currentIndex].picture)
        case .doctorList:
            return URL(string: self.doctors[currentIndex].avatar)
        }
    }

    init(homeModel: HomeModel) {
        self.articles = homeModel.data.articleList
        self.promotions = homeModel.data.promotionList
        self.doctors = homeModel.data.doctorList
    }
    
}
