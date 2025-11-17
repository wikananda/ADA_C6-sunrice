//
//  ToastMessage.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct AlertMessage: View {
    var message: String? = "message"
    var body: some View {
        Text("\(message ?? "message")")
            .multilineTextAlignment(.center)
            .font(.labelSM)
            .foregroundColor(AppColor.Primary.gray)
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(AppColor.grayscale20)
            )
    }
}

#Preview {
    AlertMessage()
}
