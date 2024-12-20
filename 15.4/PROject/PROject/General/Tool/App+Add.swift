//
//  App+Add.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import UIKit

extension App {
    struct Environment: OptionSet {
        let rawValue: Int
        init(rawValue: Int) {
            self.rawValue = rawValue
        }
        static var debug: Environment { .init(rawValue: 1 << 0) }
        static var release: Environment { .init(rawValue: 1 << 1) }
        static var development: Environment { .init(rawValue: 1 << 2) }
        static var distributed: Environment { .init(rawValue: 1 << 3) }
    }
    
    static var environment: Environment = {
        var envir: Environment = []
        #if DEBUG
        envir.formUnion(.debug)
        #else
        envir.formUnion(.release)
        #endif
        
        #if DEVELOPMENT
        envir.formUnion(.development)
        #else
        envir.formUnion(.distributed)
        #endif
        
        return envir
    }()
    /// false表示正式环境，true表示测试服环境
    static var isDevelopment: Bool {
        #if DEVELOPMENT
        return true
        #else
        return false
        #endif
    }
     
    /// 用于Release环境输出日志(true), 正式包需设置为false
    static var logEnable: Bool {
        return true
    }
    /// 是否是我们平常开发写代码的调试模式
    static var isCoding: Bool {
        #if DEVELOPMENT
        #if DEBUG
        return true
        #else
        return false
        #endif
        #else
        return false
        #endif
    }
}


