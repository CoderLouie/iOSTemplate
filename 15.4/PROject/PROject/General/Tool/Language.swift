//
//  Language.swift
//  PROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import Foundation
import SwifterKnife

extension Language { 
    /// 日语 Japanese
    static var ja: Language { .init(rawValue: "ja") }
    /// 韩语 Korean
    static var ko: Language { .init(rawValue: "ko") }
}

extension LocalizedKeyRepresentable {
    // "".hr.localized
//    var hr: LocalizedKey {
//        LocalizedKey(self, "HR")
//    }
}


extension LocalizedKeyRepresentable {
    /// 目前只做中文简体,将来要做其他多语言,只需替换该方法实现
    var tplocal: String {
//        return i18n(using: .zhHans)
        self.localized
//        self.i18n
    }
    func tplocalFormat(with args: CVarArg...) -> String {
//        return String(format: i18n(using: .zhHans), arguments: args)
        return String(format: self.tplocal, arguments: args)
    }
    func tplocalFormat(withArray args: [CVarArg]) -> String {
        return String(format: self.tplocal, arguments: args)
    }
}
