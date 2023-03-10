//
//  UserInfoModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation

struct UserInfoModel: Codable {
    let data: InfoUser
}

struct InfoUser: Codable {
    let id: Int
    let last_name: String
    let username: String
    let contact_email: String
    let name: String
    let phone: String
    let address: String
    let province_code: String
    let district_code: String
    let ward_code: String
    let blood_name: String
    let birth_date: String
}
