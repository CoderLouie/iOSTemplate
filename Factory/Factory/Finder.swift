//
//  Finder.swift
//  Terminal
//
//  Created by liyang on 2024/7/10.
//

import Foundation

enum Finder {
    
    private static var todayDate: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy/MM/dd"
        return fmt.string(from: Date())
    }
    
    static func cloneProject(fromPath: String, toPath: String) {
        do {
            try _cloneProject(fromPath: fromPath, toPath: toPath)
        } catch {
            print("Error: \(error)")
        }
    }
    private static func pathInfos(of path: String) -> (projName: String, projFile: String, podfileFold: String) {
        let nspath = (path as NSString)
        let projName = nspath.lastPathComponent
        return (projName, "\(projName).xcodeproj", "Podfile")
    }
    private static func _cloneProject(fromPath: String, toPath: String) throws {
        let mgr = FileManager.default
        if mgr.fileExists(atPath: toPath) {
            print("Warning: \(toPath) already exist!, will be remove")
            try mgr.removeItem(atPath: toPath)
        }
        try mgr.createDirectory(atPath: toPath, withIntermediateDirectories: true)
        
        let fromInfo = pathInfos(of: fromPath)
        for name in [fromInfo.0, fromInfo.1, fromInfo.2] {
            let srcPath = fromPath + name
            guard mgr.fileExists(atPath: srcPath) else { continue }
            try mgr.copyItem(atPath: srcPath, toPath: toPath + name)
        }
        let toInfo = pathInfos(of: toPath)
        let todayDate = self.todayDate
         
        let renamefile = { (path: String) throws -> Void in
            let filename = (path as NSString).lastPathComponent
            if filename.contains(fromInfo.0) {
                let newfilename = filename.replacingOccurrences(of: fromInfo.0, with: toInfo.0)
                let newpath = (path as NSString).deletingLastPathComponent + "/" + newfilename
                try mgr.moveItem(atPath: path, toPath: newpath)
            }
        }
        
        do {
            let codeFold = toPath + fromInfo.0
            try enumerateContents(of: codeFold) {
                $0.hasSuffix(".swift") ||
                $0.hasSuffix(".strings") ||
                $0.hasSuffix(".h") ||
                $0.hasSuffix(".m")
            } progress: { path, level, mgr, stop in
                try replace(of: """
//  \(fromInfo.0)
//
//  Created by liyang on TODAYS_DATE.
""", with: """
//  \(toInfo.0)
//
//  Created by liyang on \(todayDate).
""", at: path)
            }
            let bridgHeaderPath = codeFold + "/Other/\(fromInfo.0)-Bridging-Header.h"
            if mgr.fileExists(atPath: bridgHeaderPath) {
                try renamefile(bridgHeaderPath)
            }
            try renamefile(codeFold)
        }
        
        do {
            let projFold = toPath + fromInfo.1
            try enumerateContents(of: projFold) {
                $0.hasSuffix(".xcscheme") ||
                $0.hasSuffix(".pbxproj")
            } progress: { path, level, mgr, stop in
                try replace(of: fromInfo.0, with: toInfo.0, at: path)
                try renamefile(path)
            }
            try renamefile(projFold)
        }
        do {
            let profilePath = toPath + toInfo.2
            guard mgr.fileExists(atPath: profilePath) else { return }
            try replace(of: fromInfo.0, with: toInfo.0, at: profilePath)
//            Process.runPodInstall(at: toPath)
        }
    }
}

extension Finder {
    private static func replace(of target: String, with replacement: String, at path: String) throws {
        let url = URL(fileURLWithPath: path)
        let data = try Data(contentsOf: url)
        guard let string = String(data: data, encoding: .utf8) else {
            return
        }
        let result = string.replacingOccurrences(of: target, with: replacement)
        try result.data(using: .utf8)?.write(to: url, options: .atomic)
    }
    
    private static func enumerateContents(
        of path: String,
        pass condition: (String) -> Bool,
        progress:(_ path: String,
                  _ level: Int,
                  _ mgr: FileManager,
                  _ stop: inout Bool) throws -> Void) rethrows {
        
        let manager = FileManager.default
        var isDirectory: ObjCBool = false
        var stop = false
        
        func enumerateContents(of path: String, innerLevel: Int) throws {
            guard !stop else { return }
            guard manager.fileExists(atPath: path, isDirectory: &isDirectory) else {
                return
            }
            guard isDirectory.boolValue else {
                guard condition(path) else { return }
                return try progress(path, innerLevel, manager, &stop)
            }
            let contents = try manager.contentsOfDirectory(atPath: path)
            for item in contents where !item.hasPrefix(".") {
                let fullPath = (path as NSString).appendingPathComponent(item)
                try enumerateContents(of: fullPath, innerLevel: innerLevel + 1)
                if stop { break }
            }
        }
        try enumerateContents(of: path, innerLevel: 0)
    }
}
