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
        let fileURL = try! FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        print(fileURL)

        guard let windowScene = (scene as? UIWindowScene) else {return}
        window = UIWindow(windowScene: windowScene)

        let isChange = UserDefaultsManager.shared.isChange

        if isChange {
            window?.rootViewController = UINavigationController(rootViewController: ScheduleViewController())
        } else {
            window?.rootViewController = OnboardingTabViewController()
        }

        window?.makeKeyAndVisible()
    }

}

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private init() {}

    private enum Key: String {
        case isChange
    }

    var isChange: Bool {
        get {
            return UserDefaults.standard.bool(
                forKey: Key.isChange.rawValue
            )
        }
        set {
            UserDefaults.standard.set(
                newValue,
                forKey: Key.isChange.rawValue
            )
        }
    }
}
