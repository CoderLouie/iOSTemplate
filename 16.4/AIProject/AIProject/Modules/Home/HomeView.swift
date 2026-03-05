//
//  HomeView.swift
//  AIPROject
//
//  Created by liyang on 2026/3/5.
//

import SwiftUI
struct HomeView: View {
    @Environment(\.appRouter) private var router

    var body: some View {
        VStack(spacing: 16) {
            Text("Home")
                .font(.title2.weight(.semibold))

            Button("Push 到详情页") {
                router?.push(animated: true) {
                    DetailView(source: "Home")
                }
            }

            Button("切换到 Profile Tab") {
                router?.selectTab(at: AppTab.profile.rawValue)
            }
        }
        .padding(24)
    }
}
