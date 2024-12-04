//
//  UIColor+Config.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import UIKit

extension UIColor {
    
    static var theme: UIColor { UIColor(r: 68, g: 194, b: 217) }
     
    static var gray34: UIColor { UIColor(gray: 34) }
    static var gray43: UIColor { UIColor(gray: 43) }
    static var gray120: UIColor { UIColor(gray: 120) }
    static var gray180: UIColor { UIColor(gray: 180) }
     
    
    static func white(_ a: CGFloat) -> UIColor {
        UIColor(gray: 255, alpha: a)
    }
    static func black(_ a: CGFloat) -> UIColor {
        UIColor(gray: 0, alpha: a)
    }
}


extension Screen {
    // 设计稿navbar或tabbar高度和系统不一致时，可以打开下面注释
//    @objc static var _tabbarH: CGFloat { 49 }
//    @objc static var _navbarH: CGFloat { 44 }
}
