//
//  IdeaView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 19/11/25.
//

import SwiftUI

// this idea view is ideally for White and First Green hat
struct IdeaView: View {
    let ideaText: String
    let ideaId: Int
    
    var body: some View {
        HStack(spacing: 0) {
            // color can be adjusted later, regarding to idea type
            Color.blue.opacity(0.2)
                .frame(width: 16)
                .clipShape(
                    UnevenRoundedRectangle(
                        cornerRadii: .init(
                            topLeading: 20,
                            bottomLeading: 20
                        )
                    )
                )
            
            VStack(alignment: .leading) {
                            Text(ideaText)
                                .font(.body)
                                .padding(16)
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 361, alignment: .trailing)
        .fixedSize(horizontal: false, vertical: true)
        .background(
            UnevenRoundedRectangle(
                cornerRadii: .init(bottomTrailing: 20, topTrailing: 20)
            )
            .fill(Color(.white))
            .overlay(
                UnevenRoundedRectangle(
                    cornerRadii: .init(
                        topLeading: 18,
                        bottomLeading: 18,
                        bottomTrailing: 20,
                        topTrailing: 20
                    )
                )
                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
            )

        )
        .padding(.horizontal, 16)
    }
}

#Preview {
    IdeaView(
        ideaText: "Hello! This is a sample idea.",
        ideaId: 1
    )
}
