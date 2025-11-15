//
//  SkipButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct SkipButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text("SKIP")
                .font(.bodySM)
                .foregroundStyle(AppColor.Primary.gray)
        }
    }
}

#Preview {
    SkipButton(action: {})
}
