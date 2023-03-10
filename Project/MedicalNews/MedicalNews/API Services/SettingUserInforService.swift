//
//  SettingUserInforService.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation

class SettingUserInfoService {
    static let shared = SettingUserInfoService()
    private let userInfoURL = "https://gist.githubusercontent.com/hdhuy179/7883b8f11ea4b25cf6d3822c67049606/raw/Training_Intern_BasicApp_UserInfo"
    private let locationBaseURL = "https://gist.githubusercontent.com/hdhuy179/7883b8f11ea4b25cf6d3822c67049606/raw/"

    func fetchUserInfo(completion: @escaping (InfoUser?) -> Void) {
        guard let url = URL(string: userInfoURL) else {return}
        URLSession.shared.dataTask(with: url) { data, response, erro in
            guard let data = data else {
                completion(nil)
                return
            }
            
            let decoder = JSONDecoder()
            let dataDecoded = try? decoder.decode(UserInfoModel.self, from: data)
            guard let dataDecoded = dataDecoded else {return}
            completion(dataDecoded.data)
        }.resume()
    }
    
    func fetchLocationUser(user: InfoUser?, completion: @escaping (UserLocation?) -> Void) {
        guard let user = user else {return}
        guard let url = URL(string: locationBaseURL + "province_code=\(user.province_code)&district_code=\(user.district_code)&ward_code=\(user.ward_code)") else {return}
            URLSession.shared.dataTask(with: url) { data, response, erro in
                guard let data = data else {
                    completion(nil)
                    return
                }
                
                let decoder = JSONDecoder()
                let dataDecoded = try? decoder.decode(locationModel.self, from: data)
                guard let dataDecoded = dataDecoded else {return}
                completion(dataDecoded.data)
            }.resume()
    }
}
