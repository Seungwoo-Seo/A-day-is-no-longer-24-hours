//
//  SceneDelegate.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/09/28.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)
        window?.rootViewController = UINavigationController(rootViewController: SleepTimeViewController())
        window?.makeKeyAndVisible()
    }

}
