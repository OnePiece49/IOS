//
//  HomeViewModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation

enum TitleSection: Int {
    case news
    case sales
    case introDoctor
    
    var description: String {
        switch self {
        case .news:
            return "Tin tức"
        case .sales:
            return "Khuyễn mãi"
        case .introDoctor:
            return "Giới thiệu bác sĩ"
        }
    }
}
