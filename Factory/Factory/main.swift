//
//  main.swift
//  Factory
//
//  Created by liyang on 2024/7/11.
//

import Foundation


private func createPodLib() {
    let fromPath = "/Users/liyang/Desktop/Program/Unbing/SourceTree/Github/iOSTemplate/15.4/PodLib/"
    let toPath = "/Users/liyang/Desktop/Program/Unbing/SourceTree/Pods/WH/SwiftyStatistics/"
    //let toPath = "/Users/liyang/Desktop/Program/2026/04/MomSHU/"
    Finder.cloneProject(fromPath: fromPath, toPath: toPath)
}

private func createProject() {
    let fromPath = "/Users/liyang/Desktop/Program/Unbing/SourceTree/Github/iOSTemplate/15.4/PROject/"
    let toPath = "/Users/liyang/Desktop/Program/Unbing/SourceTree/Project/IssuedExample/"
    Finder.cloneProject(fromPath: fromPath, toPath: toPath)
}
private func createProject16_4() {
    let fromPath = "/Users/liyang/Desktop/Program/Unbing/SourceTree/Github/iOSTemplate/16.4/AIPROject/"
    let toPath = "/Users/liyang/Desktop/Program/2026/05/HelloExample/"
    Finder.cloneProject(fromPath: fromPath, toPath: toPath)
}
private func createDemo() {
    let fromPath = "/Users/liyang/Desktop/Program/Unbing/SourceTree/Github/iOSTemplate/15.4/Demo/"
    let toPath = "/Users/liyang/Desktop/Program/2026/04/FlashImg/"
    Finder.cloneProject(fromPath: fromPath, toPath: toPath)
}

//createDemo()
//createPodLib()
//createProject()
createProject16_4()
//Process.runPodInstall(at: toPath)


