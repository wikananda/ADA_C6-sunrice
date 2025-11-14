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
                .foregroundStyle(.black)
                .frame(width: 35, height: 35)
                .background(
                    Circle()
                        .fill(Color(.systemGray6))
                )

        }
    }
}

#Preview {
    BackButton(action: {})
}
