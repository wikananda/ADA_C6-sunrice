//
//  MoreTimeButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct MoreTimeButton: View {
    var isHost: Bool = true
    var action: () -> Void = {}
    
    private var message: String {
        isHost ? "+30s" : "Request More Time"
    }
    
    var body: some View {
        Button(action: action) {
            Label(message, systemImage: "hourglass.badge.plus")
                .font(.labelSM)
                .foregroundColor(AppColor.Primary.gray)
        }
        .padding()
        .clipShape(Capsule())
        .buttonStyle(
            MoreTimeButtonStyle(
                normal: AppColor.grayscale20,
                pressed: AppColor.whiteishBlue10,
                border: AppColor.grayscale20)
        )
        
    }
}

struct MoreTimeButtonStyle: ButtonStyle {
    var normal: Color
    var pressed: Color
    var border: Color

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(
                Capsule().fill(configuration.isPressed ? pressed : normal)
            )
            .overlay(
                Capsule().stroke(border, lineWidth: 2)
            )
            .contentShape(Capsule())
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

#Preview {
    MoreTimeButton()
}
