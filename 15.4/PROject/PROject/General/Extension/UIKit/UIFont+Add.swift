//
//  UIFont+Add.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import UIKit
import SwifterKnife

extension UIFont { 
    
    static var medium12: UIFont { .medium(12).fit }
    static var medium14: UIFont { .medium(14).fit }
    static var medium16: UIFont { .medium(16).fit }
    static var medium18: UIFont { .medium(18).fit }
    
    static var regular10: UIFont { .regular(10).fit }
    static var regular11: UIFont { .regular(11).fit }
    static var regular12: UIFont { .regular(12).fit }
    static var regular14: UIFont { .regular(14).fit }
    static var regular16: UIFont { .regular(16).fit }
    static var regular18: UIFont { .regular(18).fit }
    
    static var system12: UIFont {
        UIFont.systemFont(ofSize: 12).fit
    }
    static var system14: UIFont {
        UIFont.systemFont(ofSize: 14).fit
    }
    static var system16: UIFont {
        UIFont.systemFont(ofSize: 16).fit
    }
    static var system18: UIFont {
        UIFont.systemFont(ofSize: 18).fit
    }
    static var system20: UIFont {
        UIFont.systemFont(ofSize: 20).fit
    }
}
