//
//  RoomButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct RoomButton: View {
    var title: String
    var icon: String
    var primary: Bool = false
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Label(title, systemImage: icon)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                .font(.labelMD)
                .foregroundStyle(primary ? AppColor.grayscale10 : AppColor.Primary.gray)
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(RoundedRectangle(cornerRadius: 20).fill(primary ? AppColor.Primary.blue : AppColor.grayscale10))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AppColor.grayscale20, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    RoomButton(title: "TITLE", icon: "star.fill") {}
}

// MARK: - Convenience style helpers
extension RoomButton {
    func asPrimary() -> RoomButton {
        RoomButton(title: title, icon: icon, primary: true, action: action)
    }

    func asSecondary() -> RoomButton {
        RoomButton(title: title, icon: icon, primary: false, action: action)
    }
}
