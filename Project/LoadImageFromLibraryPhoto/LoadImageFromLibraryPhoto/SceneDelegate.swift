//
//  SceneDelegate.swift
//  LoadImageFromLibraryPhoto
//
//  Created by Long Bảo on 02/05/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scence = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scence)
        self.window = window
        window.rootViewController = ViewController()
        window.makeKeyAndVisible()
    }


}

