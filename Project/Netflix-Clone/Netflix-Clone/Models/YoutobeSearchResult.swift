//
//  YoutobeSearchResult.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 04/02/2023.
//

import Foundation

struct YoutobeSearchResults: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable {
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String
}
