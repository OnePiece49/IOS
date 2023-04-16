//
//  HomeService.swift
//  MedicalNews
//
//  Created by Long Bảo on 07/03/2023.
//

import Foundation

class HomeSerVice {
    private let ariticleURL = "https://gist.githubusercontent.com/hdhuy179/f967ffb777610529b678f0d5c823352a/raw"
    static let shared = HomeSerVice()
    
    func fetchArticleList(completion: @escaping([ArticleModel]) -> Void) {
        guard let url = URL(string: ariticleURL) else {return}
        URLSession.shared.dataTask(with: url) { data, _, erorr in
            if let erorr = erorr {
                print("DEBUG: \(erorr.localizedDescription)")
                return
            }
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            let dataDecode = try? decoder.decode(HomeModel.self, from: data)
            guard let dataDecode = dataDecode else {return}
            completion(dataDecode.data.articleList)
        }.resume()
    }
    
    func fetchPromotionList(completion: @escaping([PromotionModel]) -> Void) {
        guard let url = URL(string: ariticleURL) else {return}
        URLSession.shared.dataTask(with: url) { data, _, erorr in
            if let erorr = erorr {
                print("DEBUG: \(erorr.localizedDescription)")
                return
            }
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            let dataDecode = try? decoder.decode(HomeModel.self, from: data)
            guard let dataDecode = dataDecode else {return}
            completion(dataDecode.data.promotionList)
        }.resume()
    }
    
    func fetchDoctorList(completion: @escaping([DoctorModel]) -> Void) {
        guard let url = URL(string: ariticleURL) else {return}
        URLSession.shared.dataTask(with: url) { data, _, erorr in
            if let erorr = erorr {
                print("DEBUG: \(erorr.localizedDescription)")
                return
            }
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            let dataDecode = try? decoder.decode(HomeModel.self, from: data)
            guard let dataDecode = dataDecode else {return}
            completion(dataDecode.data.doctorList)
        }.resume()
    }
    
    func fetchAllData(completion: @escaping(HomeModel) -> Void) {
        guard let url = URL(string: ariticleURL) else {return}
        URLSession.shared.dataTask(with: url) { data, _, erorr in
            if let erorr = erorr {
                print("DEBUG: \(erorr.localizedDescription)")
                return
            }
            
            guard let data = data else {return}
            let decoder = JSONDecoder()
            let dataDecode = try? decoder.decode(HomeModel.self, from: data)
            guard let dataDecode = dataDecode else {return}
            completion(dataDecode)
        }.resume()
    }
    
    
}
