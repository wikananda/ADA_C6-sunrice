//
//  AppButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct AppButton: View {
    @Environment(\.isEnabled) private var isEnabled
    var title: String
    var action: () -> Void
    
    var body: some View {
        // Effective visual state follows both the explicit `active`
        // flag and the environment's enabled state (set by .disabled()).
        let isVisuallyActive = isEnabled
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 64)
                .font(.labelMD)
                .foregroundStyle(isVisuallyActive ? AppColor.grayscale10 : AppColor.grayscale20)
        }
        .background(isVisuallyActive ? AppColor.Primary.blue : AppColor.whiteishBlue10)
        .clipShape(Capsule())
    }
}


#Preview {
    AppButton(title: "Text") {}
//        .disabled(true)
}

// MARK: - Convenience style helper

// extension AppButton {
//     func isActive(_ active: Bool) -> AppButton {
//         AppButton(title: title, active: active, action: action)
//     }
// }
