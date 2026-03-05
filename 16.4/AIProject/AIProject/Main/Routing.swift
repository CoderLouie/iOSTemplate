//
//  Routing.swift
//  AIPROject
//
//  Created by liyang on 2026/3/5.
//

import SwiftUI
import UIKit

protocol AppRouting: AnyObject {
    func push<Content: View>(animated: Bool, @ViewBuilder _ content: () -> Content)
    func present<Content: View>(
        wrappedInNavigation: Bool,
        animated: Bool,
        @ViewBuilder _ content: () -> Content
    )
    func setRoot<Content: View>(animated: Bool, @ViewBuilder _ content: () -> Content)
    func pop(animated: Bool)
    func dismiss(animated: Bool)
    func selectTab(at index: Int)
}

private struct AppRouterKey: EnvironmentKey {
    static let defaultValue: (any AppRouting)? = nil
}

extension EnvironmentValues {
    var appRouter: (any AppRouting)? {
        get { self[AppRouterKey.self] }
        set { self[AppRouterKey.self] = newValue }
    }
}

final class HostingPageController: UIHostingController<AnyView> {
    init<Content: View>(router: any AppRouting, @ViewBuilder content: () -> Content) {
        let root = AnyView(content().environment(\.appRouter, router))
        super.init(rootView: root)
    }

    @available(*, unavailable)
    dynamic required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

final class AppRouter: AppRouting {
    private weak var navigationController: UINavigationController?
    private weak var tabBarController: UITabBarController?

    init(
        navigationController: UINavigationController? = nil,
        tabBarController: UITabBarController? = nil
    ) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }

    func bindNavigationController(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func bindTabBarController(_ tabBarController: UITabBarController) {
        self.tabBarController = tabBarController
    }

    func push<Content: View>(animated: Bool = true, @ViewBuilder _ content: () -> Content) {
        let controller = HostingPageController(router: self, content: content)
        navigationController?.pushViewController(controller, animated: animated)
    }

    func present<Content: View>(
        wrappedInNavigation: Bool = true,
        animated: Bool = true,
        @ViewBuilder _ content: () -> Content
    ) {
        let controller = HostingPageController(router: self, content: content)
        
        if wrappedInNavigation {
            let navigation = AppNavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            navigationController?.present(navigation, animated: animated)
        } else {
            controller.modalPresentationStyle = .fullScreen
            navigationController?.present(controller, animated: animated)
        }
    }

    func setRoot<Content: View>(animated: Bool = false, @ViewBuilder _ content: () -> Content) {
        let controller = HostingPageController(router: self, content: content)
        navigationController?.setViewControllers([controller], animated: animated)
    }

    func pop(animated: Bool = true) {
        navigationController?.popViewController(animated: animated)
    }

    func dismiss(animated: Bool = true) {
        navigationController?.dismiss(animated: animated)
    }

    func selectTab(at index: Int) {
        tabBarController?.selectedIndex = index
    }
}
