//
//  Extension.swift
//  Netflix-Clone
//
//  Created by Long Bảo on 03/02/2023.
//

import Foundation

extension String {
    func convertSectionTitle() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
