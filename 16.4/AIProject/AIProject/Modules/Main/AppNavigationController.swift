//
//  AppNavigationController.swift
//  AIPROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
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
