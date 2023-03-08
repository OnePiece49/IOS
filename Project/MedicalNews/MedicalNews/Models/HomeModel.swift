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
    let articleList: [ArticleList]
    let promotionList: [PromotionList]
    let doctorList: [DoctorList]
}


struct ArticleList: Codable {
    let id: Int
    let title: String
    let picture: String
    let picture_caption: String
    let created_at: String
    let link: String
}

struct PromotionList: Codable {
    let id: Int
    let name: String
    let picture: String
    let created_at: String
    let link: String
    
}

struct DoctorList: Codable {
    let id: Int
    let full_name: String
    let name: String
    let ratio_star: Double
    let number_of_reviews: Int
    let avatar: String
    let majors_name: String
}
