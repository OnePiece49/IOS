//
//  FakeController.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import Foundation
import UIKit

class FakeController: UIViewController {
    //MARK: - Properties
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    
    
    
    //MARK: - Helpers
    ///Nếu Push thẳng MainTabBarController từ Scence sang sẽ bị navigation to và titleView bị thụt xuống dưới, nên ta phải làm thế này.
    func configureUI() {
        let mainTabBarController = MainTabBarController()
        mainTabBarController.modalPresentationStyle = .fullScreen
        present(mainTabBarController, animated: true, completion: .none)
        
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
