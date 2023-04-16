//
//  DoctorViewModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit

struct DoctorViewModel {
    var doctorList: [DoctorModel]
    
    var currentIndex: Int = 1
    
    var numberDoctor: Int {
        return doctorList.count
    }
    
    var userNameDoctorString: String {
        return "BS. " + doctorList[currentIndex].full_name
    }
    
    var majorDoctorString: String {
        return "Chuyên ngành: " + doctorList[currentIndex].majors_name
 
    }
    
    var reviewTextAttributed: NSAttributedString {
        let textAttributed = NSMutableAttributedString(string:  "\(doctorList[currentIndex].ratio_star) ", attributes: .none)
        textAttributed.append(NSAttributedString(string: "(\(doctorList[currentIndex].number_of_reviews))", attributes: [NSAttributedString.Key.font: UIFont(name: "NunitoSans-Regular", size: 15) ?? UIFont.boldSystemFont(ofSize: 14), NSAttributedString.Key.foregroundColor: UIColor(red: 0.557, green: 0.604, blue: 0.671, alpha: 1)]))
        return textAttributed
    }
    
    var imageURL: URL? {
        return URL(string: self.doctorList[currentIndex].avatar)
        
    }

    init(doctorList: [DoctorModel]) {
        self.doctorList = doctorList
    }
}

