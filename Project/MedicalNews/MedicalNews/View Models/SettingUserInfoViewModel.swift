//
//  SettingUserInfoViewModel.swift
//  MedicalNews
//
//  Created by Long Bảo on 10/03/2023.
//

import Foundation
import UIKit

enum SettingOption: Int, CaseIterable {
    case name
    case lastname
    case date
    case sex
    case phoneNumber
    case email
    case city
    case district
    case ward
    case address
    case typeBlood
}

class SettingUserInfoViewModel {
    var data: InfoUser?
    var completion: ((Bool) -> Void) = { _ in}
    
    func fetchNewData() {
        SettingUserInfoService.shared.fetchUserInfo { data in
            guard let data = data else {
                self.completion(false)
                return
            }
            self.data = data
            self.completion(true)
        }
    }
}

struct SettingUserInfoCellViewModel {
     let option: SettingOption
    var user: InfoUser?
    var location: UserLocation?
    
    var dataString: String {
        guard let user = user else {
            return ""
        }

        switch option {
        case .lastname:
            return user.last_name
        case .name:
            return user.name
        case .date:
            return user.birth_date
        case .sex:
            return "Giới tính"
        case .phoneNumber:
            return user.phone
        case .email:
            return user.contact_email
        case .city:
            return location?.province_name ?? ""
        case .district:
            return location?.district_name ?? ""
        case .ward:
            return location?.ward_name ?? ""
        case .address:
            return user.address
        case .typeBlood:
            return user.blood_name
        }
    }
    
    var placeholderString: String {
        switch option {
        case .lastname:
            return "Nhập họ của bạn"
        case .name:
            return "Nhập tên của bạn"
        case .date:
            return "DD/MM/YY"
        case .sex:
            return "Giới tính"
        case .phoneNumber:
            return "Nhập số điện thoại"
        case .email:
            return "Địa chỉ email của bạn"
        case .city:
            return "Chưa cập nhập"
        case .district:
            return "Chưa cập nhập"
        case .ward:
            return "Chưa cập nhập"
        case .address:
            return "Chưa cập nhập"
        case .typeBlood:
            return "A+/B+/AB/O"
        }
    }
    
    var titleString: String {
        switch option {
        case .lastname:
            return "Họ *"
        case .name:
            return "Tên *"
        case .date:
            return "Ngày sinh *"
        case .sex:
            return "Giới tính"
        case .phoneNumber:
            return "Số điện thoại"
        case .email:
            return "Email"
        case .city:
            return "Tỉnh / Thành phố"
        case .district:
            return "Quận / Huyện"
        case .ward:
            return "Phường / Xã"
        case .address:
            return "Địa chỉ nơi ở"
        case .typeBlood:
            return "Nhóm máu"
        }
    }
    
    init(option: SettingOption, user: InfoUser? = nil, location: UserLocation? = nil) {
        self.option = option
        self.user = user
        self.location = location
    }
}

