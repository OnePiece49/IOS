//
//  ViewController.swift
//  Test_RetailCycle
//
//  Created by Long Bảo on 23/02/2023.
//

import UIKit


class People {
    static let shared: People = People()
    deinit {
        print("deinit People")
    }

    var ab = "Vietdz"
    func say_hello(completion: @escaping(String) -> Void) {
        URLSession.shared.dataTask(with: URL(string: "https://www.google.com.vn")!) { data, _, e in
            completion("Hello")
            self.ab = "KAKA"
        }.resume()
        self.ab = "KAKA"
    }
}

class Human {
    var a = "HIHI"
    func say_haha() {
        People().say_hello { hihi in
            self.a = hihi
        }
    }
    
    deinit {
        print("Human deinit")
    }
}

class ViewController: UIViewController {
    
    var a = "123"
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        testRetailCycle()
    }

    func testRetailCycle() {
        Human().say_haha()
        People().say_hello { kaka in
            print("KAKa")
            self.a = kaka
        }
    }
    
    
}

