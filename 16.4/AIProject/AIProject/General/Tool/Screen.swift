//
//  Screen.swift
//  AIPROject
//
//  Created by liyang on 2026/3/12.
//

import UIKit

enum Screen {
    
    @available(iOS 13.0, *)
    public static var activeWindowScene: UIWindowScene? {
        return UIApplication.shared.connectedScenes.first {
            $0.activationState == .foregroundActive &&
            ($0 as? UIWindowScene) != nil
        } as? UIWindowScene
    }
    public static var keyWindow: UIWindow? {
        if #available(iOS 13.0, *) {
            return activeWindowScene?.windows.first {
                $0.isKeyWindow
            }
        } else {
            return UIApplication.shared.keyWindow
        }
    }
    public static var delegateWindow: UIWindow? {
        UIApplication.shared.delegate?.window ?? nil
    }
    
    public static var currentWindow: UIWindow? {
        delegateWindow ?? keyWindow
    }
    
    public static var rootViewController: UIViewController? {
        guard let window = currentWindow,
              let rootVC = window.rootViewController else {
            return nil
        }
        return rootVC
    }
    public static var frontViewController: UIViewController? {
        return rootViewController?.front()
    }
}


extension UIViewController {
   public func front() -> UIViewController {
       if let presented = presentedViewController {
           return presented.front()
       } else if let nav = self as? UINavigationController,
                 let visible = nav.visibleViewController {
           return visible.front()
       } else if let tab = self as? UITabBarController,
                 let selected = tab.selectedViewController {
           return selected.front()
       } else if let page = self as? UIPageViewController,
                 let vcs = page.viewControllers,
                 vcs.count == 1 {
           return vcs[0].front()
       } else {
           for vc in children.reversed() {
               if vc.view.window != nil {
                   return vc.front()
               }
           }
           return self
       }
   }
}
