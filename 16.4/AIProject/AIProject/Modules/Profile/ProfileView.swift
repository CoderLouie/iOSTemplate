//
//  ProfileView.swift
//  AIPROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import SwiftUI


struct ProfileView: View { 

    var body: some View {
        VStack(spacing: 16) {
            Text("Profile")
                .font(.title2.weight(.semibold))

            Button("Present 模态页") {
                xPresent(
                    wrappedInNavigation: true,
                    animated: true
                ) {
                    ModalView(source: "Profile")
                }
            }

            Button("Push 详情页") {
                xPush(animated: true) {
                    DetailView(source: "Profile")
                }
            }
        }
        .padding(24)
    }
}
