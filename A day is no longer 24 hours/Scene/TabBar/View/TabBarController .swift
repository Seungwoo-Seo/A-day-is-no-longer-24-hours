//
//  TabBarController.swift
//  A day is no longer 24 hours
//
//  Created by 서승우 on 2023/10/30.
//

import UIKit

enum TabBarItem: Int, CaseIterable {
    case schedule
    case setting

    var viewController: UIViewController {
        switch self {
        case .schedule:
            let vc = UINavigationController(rootViewController: ScheduleViewController())
            vc.tabBarItem = UITabBarItem(
                title: "스케쥴",
                image: UIImage(systemName: "calendar"),
                tag: rawValue
            )
            return vc

        case .setting:
            let vc = UINavigationController(rootViewController: SettingViewController())
            vc.tabBarItem = UITabBarItem(
                title: "설정",
                image: UIImage(systemName: "ellipsis"),
                tag: rawValue
            )
            return vc
        }
    }
}

final class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.tintColor = Constraints.Color.systemBlue
        tabBar.unselectedItemTintColor = Constraints.Color.white
        viewControllers = TabBarItem.allCases.map { $0.viewController }
    }

}
