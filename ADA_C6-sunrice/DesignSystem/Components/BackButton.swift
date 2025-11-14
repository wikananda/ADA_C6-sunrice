//
//  BackButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct BackButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(AppColor.Primary.gray)
                .frame(width: 35, height: 35)
                .background(
                    Circle()
                        .fill(Color(AppColor.blue10))
                )

        }
    }
}

#Preview {
    BackButton(action: {})
}
