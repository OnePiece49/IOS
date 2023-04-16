//
//  HomeCollectionViewCellModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 15/04/2023.
//

import Foundation
import UIKit

class HomeCollectionViewCellModel {
    private var articleModel: ArticleModel?
    private var promotionModel: PromotionModel?
    private var doctorModel: DoctorModel?
    

    init(option: TitleSection,
         articleModel: ArticleModel? = nil, promotionModel: PromotionModel? = nil,
         doctorModel: DoctorModel? = nil
    ) {
        switch option {
        case .articlesList:
            self.articleModel = articleModel
        case .promotionList:
            self.promotionModel = promotionModel
        case .doctorList:
            self.doctorModel = doctorModel
        }
    }
    
    
    func getMainTextAttributed(option: TitleSection) -> NSAttributedString {
            switch option {
            case .articlesList:
                let textAttributed = NSMutableAttributedString(string: self.articleModel?.title ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 17)])
                return textAttributed
            case .promotionList:
                let textAttributed = NSMutableAttributedString(string: self.promotionModel?.name ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Bold", size: 15) ?? UIFont.boldSystemFont(ofSize: 17)])
                return textAttributed
            case .doctorList:
                return NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
            }
        }
    
    func getSubTextAttributed(option: TitleSection) -> NSAttributedString {
            switch option {
            case .articlesList:
                let textAttributed = NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
                textAttributed.append(NSAttributedString(string: " • ", attributes: [ NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.851, green: 0.859, blue: 0.882, alpha: 1)]))
                textAttributed.append(NSAttributedString(string: self.articleModel?.created_at ?? "", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)]))
                return textAttributed
    
            case .promotionList:
                let textAttributed = NSMutableAttributedString(string: "Ưu đãi hot", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
                textAttributed.append(NSAttributedString(string: " • ", attributes: [ NSMutableAttributedString.Key.foregroundColor: UIColor(red: 0.851, green: 0.859, blue: 0.882, alpha: 1)]))
                textAttributed.append(NSAttributedString(string: self.promotionModel?.created_at ?? "123", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 17), NSAttributedString.Key.foregroundColor: UIColor(red: 0.588, green: 0.608, blue: 0.671, alpha: 1)]))
                return textAttributed
            case .doctorList:
                return NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Regular", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
            }
        }
    
    func getUserNameDoctorString(option: TitleSection) -> String {
            if option == .doctorList {
                return self.doctorModel?.full_name ?? ""
            } else {
                return ""
            }
        }
    
        func getMajorDoctorString(option: TitleSection) -> String {
            if option == .doctorList {
                return self.doctorModel?.majors_name ?? ""
            } else {
                return ""
            }
        }
    
    func getReviewTextAttributed(option: TitleSection) -> NSAttributedString {
            if option == .doctorList {
                let textAttributed = NSMutableAttributedString(string:  "\(self.doctorModel?.ratio_star ?? 0) ", attributes: .none)
                textAttributed.append(NSAttributedString(string: "(\(self.doctorModel?.number_of_reviews ?? 0))", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 15) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 0.557, green: 0.604, blue: 0.671, alpha: 1)]))
                return textAttributed
            } else {
                return NSMutableAttributedString(string: "", attributes: [NSAttributedString.Key.font : UIFont(name: "NunitoSans-Bold", size: 13) ?? UIFont.boldSystemFont(ofSize: 13), NSAttributedString.Key.foregroundColor: UIColor(red: 0.173, green: 0.525, blue: 0.404, alpha: 1)])
            }
        }
    
    func getImageURL(option: TitleSection) -> URL? {
            switch option {
            case .articlesList:
                return URL(string: self.articleModel?.picture ?? "")
            case .promotionList:
                return URL(string: self.promotionModel?.picture ?? "")
            case .doctorList:
                return URL(string: self.doctorModel?.avatar ?? "")
            }
        }

}
