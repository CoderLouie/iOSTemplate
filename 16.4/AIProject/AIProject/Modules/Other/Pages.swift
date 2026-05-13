//
//  Pages.swift
//  AIPROject
//
//  Created by ${USER_NAME} on TODAYS_DATE.
//

import SwiftUI

struct DetailView: View {
    let source: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Detail")
                .font(.title2.weight(.semibold))
            Text("from \(source)")
                .foregroundStyle(.secondary)

            Button("返回上一页") {
                xPop(animated: true)
            }
        }
        .padding(24)
    }
}

struct ModalView: View {
    let source: String

    var body: some View {
        VStack(spacing: 16) {
            Text("Modal")
                .font(.title2.weight(.semibold))
            Text("presented by \(source)")
                .foregroundStyle(.secondary)

            Button("关闭模态页") { 
                xDismiss(animated: true)
            }
        }
        .padding(24)
    }
}
