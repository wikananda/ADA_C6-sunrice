//
//  RoomButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct RoomButton: View {
    @Environment(\.isEnabled) private var isEnabled
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
                .foregroundStyle(
                    primary ?
                    (isEnabled ? AppColor.grayscale10 : AppColor.grayscale20)
                    : (isEnabled ? AppColor.Primary.gray : AppColor.grayscale20))
        }
        .frame(maxWidth: .infinity, maxHeight: 80)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(primary ?
                      (isEnabled ? AppColor.Primary.blue : AppColor.whiteishBlue10) : AppColor.grayscale10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .strokeBorder(AppColor.grayscale20, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    RoomButton(title: "TITLE", icon: "star.fill") {}
//        .asPrimary()
//        .disabled(true)
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
