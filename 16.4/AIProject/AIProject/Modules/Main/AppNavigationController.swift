//
//  AppNavigationController.swift
//  AIPROject
//
//  Created by liyang on 2026/3/5.
//

import UIKit

final class AppNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigationBarHidden(true, animated: false)
//        delegate = self
    }
    
    override var childForStatusBarStyle: UIViewController? {
        topViewController
    }
    override var childForStatusBarHidden: UIViewController? {
        topViewController
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        defer { super.pushViewController(viewController, animated: animated) }
        guard viewControllers.count > 0 else { return }
        viewController.hidesBottomBarWhenPushed = true
    }
}
