//
//  TrendingTvModel.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import Foundation

struct ResultAPICaller: Codable {
    let results: [DataAPI]
}

struct DataAPI: Codable {
    let id: Int
    let media_type: String?
    let original_title: String?
    let overview: String?
    let release_date: String?
    let vote_average: Double
    let vote_count: Int
    let poster_path: String?
}
