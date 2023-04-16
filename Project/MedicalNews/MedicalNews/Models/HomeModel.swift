//
//  HomeModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation

struct HomeModel: Codable {
    let status: Int
    let message: String
    let data: Data
}

struct Data: Codable {
    let articleList: [ArticleModel]
    let promotionList: [PromotionModel]
    let doctorList: [DoctorModel]
}


struct ArticleModel: Codable {
    let id: Int
    let title: String
    let picture: String
    let picture_caption: String
    let created_at: String
    let link: String
}

struct PromotionModel: Codable {
    let id: Int
    let name: String
    let picture: String
    let created_at: String
    let link: String
    
}

struct DoctorModel: Codable {
    let id: Int
    let full_name: String
    let name: String
    let ratio_star: Double
    let number_of_reviews: Int
    let avatar: String
    let majors_name: String
}
