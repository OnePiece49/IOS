//
//  LocationModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation

struct locationModel: Codable {
    let data: UserLocation
}

struct UserLocation: Codable {
    let province_name: String
    let district_name: String
    let ward_name: String
}
