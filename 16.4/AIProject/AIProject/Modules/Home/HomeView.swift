//
//  HomeView.swift
//  AIPROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import SwiftUI
struct HomeView: View { 

    var body: some View {
        VStack(spacing: 16) {
            Text("Home")
                .font(.title2.weight(.semibold))

            Button("Push 到详情页") {
                xPush(animated: true) {
                    DetailView(source: "Home")
                }
            }

            Button("切换到 Profile Tab") {
                xSelectTab(at: AppTab.profile.rawValue)
            }
        }
        .padding(24)
    }
}
