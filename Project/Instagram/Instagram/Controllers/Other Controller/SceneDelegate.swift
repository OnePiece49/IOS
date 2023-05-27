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
        let navi = UINavigationController(rootViewController: MainTabBarController())
        navi.navigationBar.isHidden = true
        window.rootViewController = navi
        window.makeKeyAndVisible()

    }

}

