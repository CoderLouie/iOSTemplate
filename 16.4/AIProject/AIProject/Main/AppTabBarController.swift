//
//  AppTabBarController.swift
//  AIPROject
//
//  Created by liyang on 2026/3/5.
//

import UIKit

enum AppTab: Int, CaseIterable {
    case home
    case profile

    var index: Int { rawValue }

    var title: String {
        switch self {
        case .home:
            return "Home"
        case .profile:
            return "Profile"
        }
    }

    var systemImageName: String {
        switch self {
        case .home:
            return "house"
        case .profile:
            return "person.circle"
        }
    }
}


final class AppTabBarController: UITabBarController {
    private var routers: [AppRouter] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        viewControllers = AppTab.allCases.map(makeNavigationController(for:))
    }

    private func makeNavigationController(for tab: AppTab) -> UINavigationController {
        let navigationController = AppNavigationController()
        let router = AppRouter(
            navigationController: navigationController,
            tabBarController: self
        )
        routers.append(router)

        let rootController: UIViewController
        switch tab {
        case .home:
            rootController = HostingPageController(router: router) {
                HomeView()
            }
        case .profile:
            rootController = HostingPageController(router: router) {
                ProfileView()
            }
        }
        rootController.tabBarItem = UITabBarItem(
            title: tab.title,
            image: UIImage(systemName: tab.systemImageName),
            selectedImage: nil
        )
        navigationController.setViewControllers([rootController], animated: false)
        return navigationController
    }
}
