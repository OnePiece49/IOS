//
//  SceneDelegate.swift
//  Instagram
//
//  Created by Long Bảo on 18/04/2023.
//

import UIKit
import FirebaseCore

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        window.makeKeyAndVisible()
//        window.rootViewController = UINavigationController(rootViewController: MainTabBarController())
        window.rootViewController = MainTabBarController()
    }

}

