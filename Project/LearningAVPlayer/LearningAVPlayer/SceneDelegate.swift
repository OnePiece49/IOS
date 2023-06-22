//
//  SceneDelegate.swift
//  LearningAVPlayer
//
//  Created by Long Bảo on 21/06/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    @available(iOS 13.0, *)
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scence = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scence)
        self.window = window
        window.rootViewController = UINavigationController(rootViewController: ShowingController())
        window.makeKeyAndVisible()
    }

}

