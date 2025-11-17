//
//  IdeaBubbleView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 10/11/25.
//

import SwiftUI

struct IdeaBubbleView: View {
    let text: String
    let ideaId: Int
    var onTapPlus: (Int) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 8) {
            Spacer()

            Text(text)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .frame(maxWidth: 280, alignment: .trailing)

            Button {
                onTapPlus(ideaId)
            } label: {
                Image(systemName: "plus.circle")
                    .font(.system(size: 20))
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 4)
    }
}


#Preview {
    IdeaBubbleView(
        text: "Hello! This is a sample idea.",
        ideaId: 1
    )
}

