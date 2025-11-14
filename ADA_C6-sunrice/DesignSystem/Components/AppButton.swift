//
//  AppButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct AppButton: View {
    var title: String
    var active: Bool = true
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity, maxHeight: 64)
                .font(.system(size: 16))
                .bold(true)
                .foregroundStyle(active ? AppColor.grayscale10 : AppColor.grayscale20)
        }
        .background(active ? AppColor.Primary.blue : AppColor.whiteishBlue10)
        .clipShape(Capsule())
    }
}


#Preview {
    AppButton(title: "Text") {}
//        .isActive(false)
}

// MARK: - Convenience style helper

extension AppButton {
    func isActive(_ active: Bool) -> AppButton {
        AppButton(title: title, active: active, action: action)
    }
}
