//
//  BoxField.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct BoxField: View {
    var placeholder: String? = "e.g., “How might we make onboarding more delightful?”, “Exploring sustainable ideas.”, etc."
    @Binding var text: String
    var lineRange: ClosedRange<Int> = 1...4
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            if text.isEmpty, let placeholder {
                Text(placeholder)
                    .font(.bodySM)
                    .italic(true)
                    .foregroundStyle(AppColor.grayscale30)
                    .multilineTextAlignment(.leading)
                    .lineLimit(lineRange)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 12)
            }
            TextField("", text: $text, axis: .vertical)
                .font(.bodySM)
                .lineLimit(lineRange)
                .textFieldStyle(.plain)
                .padding(12)
                .accessibilityLabel(placeholder ?? "")
        }
        .frame(maxWidth: .infinity, minHeight: 72, alignment: .topLeading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColor.grayscale10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(AppColor.grayscale20, lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    @Previewable @State var text: String = ""
    return BoxField(text: $text)
}
