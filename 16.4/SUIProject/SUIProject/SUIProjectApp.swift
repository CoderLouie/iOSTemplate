//
//  SUIProjectApp.swift
//  SUIProject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import SwiftUI

@main
struct SUIProjectApp: App {
    
    init() {
        print(Bundle.main.infoDictionary?["CFBundleIdentifier"])
        #if DEVELOPMENT
        print("development")
        #else
        print("distributed")
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            RootTabView()
        }
    }
}
