//
//  CommentController.swift
//  Instagram
//
//  Created by Long Bảo on 25/05/2023.
//

import UIKit

class CommentController: UIViewController {
    //MARK: - Properties
    var navigationbar: NavigationCustomView!
    
    //MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        configureProperties()
    }
    
    
    
    //MARK: - Helpers
    func configureUI() {
        
    }
    
    func configureProperties() {
        
    }
    
    func setupNavigationBar() {
        let attributeFirstLeftButton = AttibutesButton(image: UIImage(named: "like1"),
                                                       sizeImage: CGSize(width: 23, height: 23)) {
            self.navigationController?.popViewController(animated: true)
        }
                                                   
        let attributeFirstRightButton = AttibutesButton(image: UIImage(named: "share"),
                                                        sizeImage: CGSize(width: 28, height: 28))
                                                   
        self.navigationbar = NavigationCustomView(centerTitle: "Comment",
                                              attributeLeftButtons: [attributeFirstLeftButton],
                                              attributeRightBarButtons: [attributeFirstRightButton],
                                              isHiddenDivider: true,
                                              beginSpaceLeftButton: 15,
                                              beginSpaceRightButton: 20)
    }
    
    //MARK: - Selectors
    
}
//MARK: - delegate
