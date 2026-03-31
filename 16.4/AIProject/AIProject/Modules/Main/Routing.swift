//
//  Routing.swift
//  AIPROject
//
//  Created by liyang on 2026/3/5.
//

import SwiftUI
import UIKit

fileprivate extension Screen {
    static var tabBarController: UITabBarController? {
        rootViewController as? UITabBarController
    }
    static var frontNavController: UINavigationController? {
        frontViewController?.navigationController
    }
}
protocol ViewLifeCycle {
    func viewDidAppear()
}
extension ViewLifeCycle {
    func viewDidAppear() {}
}
final class HostingController<Content: View>: UIHostingController<Content> {
    override func viewDidAppear(_ animated: Bool) {
        if let c = rootView as? ViewLifeCycle {
            c.viewDidAppear()
        }
    }
}
extension View {
    func xPush<Content: View>(animated: Bool = true, @ViewBuilder _ content: () -> Content) {
        guard let nav = Screen.frontNavController else { return }
        let controller = HostingController(rootView: content())
        nav.pushViewController(controller, animated: animated)
    }

    func xPresent<Content: View>(
        wrappedInNavigation: Bool = true,
        animated: Bool = true,
        @ViewBuilder _ content: () -> Content
    ) {
        guard let frontVC = Screen.frontViewController else { return }
        let controller = UIHostingController(rootView: content())
        
        if wrappedInNavigation {
            let navigation = AppNavigationController(rootViewController: controller)
            navigation.modalPresentationStyle = .fullScreen
            frontVC.present(navigation, animated: animated)
        } else {
            controller.modalPresentationStyle = .fullScreen
            frontVC.present(controller, animated: animated)
        }
    }

    func xSetRoot<Content: View>(animated: Bool = false, @ViewBuilder _ content: () -> Content) {
        guard let nav = Screen.frontNavController else { return }
        let controller = UIHostingController(rootView: content())
        nav.setViewControllers([controller], animated: animated)
    }

    func xPop(animated: Bool = true) {
        guard let nav = Screen.frontNavController else { return }
        nav.popViewController(animated: animated)
    }

    func xDismiss(animated: Bool = true) {
        guard let frontVC = Screen.frontViewController else { return }
        frontVC.dismiss(animated: animated)
    }

    func xSelectTab(at index: Int) {
        guard let tabVC = Screen.tabBarController else { return }
        tabVC.selectedIndex = index
    }
}

 
