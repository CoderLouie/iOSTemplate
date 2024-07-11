//
//  Process+Add.swift
//  Factory
//
//  Created by liyang on 2024/7/11.
//

import Foundation


extension Process {
    @discardableResult
    static func execute(at path: String, 
                        directory: String? = nil,
                        environment: [String: String]? = nil,
                        args: String...) -> (String, Bool) {
        let process = Process()
        process.launchPath = path
        process.arguments = args
        if let environment = environment {
            process.environment = environment
        }
        if let directory = directory {
            process.currentDirectoryPath = directory
        }
        let pipe = Pipe()
        process.standardOutput = pipe
        process.launch()
        do {
            guard let data = try pipe.fileHandleForReading.readToEnd() else {
                return ("no data", false)
            }
            let desc = String(data: data, encoding: .utf8) ?? ""
            return (desc, true)
        } catch {
            return ("\(error)", false)
        }
    }
    
    @discardableResult
    static func runPodInstall(at path: String) -> Bool {
        let binPath = "/Users/liyang/.rvm/gems/ruby-3.3.1/bin:/Users/liyang/.rvm/gems/ruby-3.3.1@global/bin:/Users/liyang/.rvm/rubies/ruby-3.3.1/bin:/opt/homebrew/bin:/opt/homebrew/sbin:/usr/local/bin:/System/Cryptexes/App/usr/bin:/usr/bin:/bin:/usr/sbin:/sbin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/local/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/bin:/var/run/com.apple.security.cryptexd/codex.system/bootstrap/usr/appleinternal/bin:/Library/Apple/usr/bin:/Applications/iTerm.app/Contents/Resources/utilities:/Users/liyang/.rvm/bin"
        let homeDir = NSHomeDirectory().appending("/.cocoapods")
        let res = Process.execute(at: "/usr/local/bin/pod",
                                directory: path,
                                environment: ["LANG": "en_US.UTF-8",
                                              "PATH": binPath,
                                              "CP_HOME_DIR": homeDir],
                                args: "install")
        print("run pod install \(res.0)")
        return res.1
    }
}
