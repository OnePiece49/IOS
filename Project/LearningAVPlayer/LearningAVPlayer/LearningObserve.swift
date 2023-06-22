//
//  LearningObserve.swift
//  LearningAVPlayer
//
//  Created by Long Bảo on 21/06/2023.
//

import Foundation


class Children: NSObject {
    @objc dynamic var name: String
    @objc dynamic var age: Int
    @objc dynamic var child: Children?

    override init() {
        name = ""
        age = 0
        super.init()

    }
}
