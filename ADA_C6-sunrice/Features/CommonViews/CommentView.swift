//
//  CommentView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 19/11/25.
//

import SwiftUI

// this view is ideally for Second Green, Yellow, Black, and Red Hats
// this view is basically similar with IdeaView, the difference is just the width
struct CommentView: View {
    var body: some View {
        HStack(spacing: 0) {
            // color can be adjusted later, regarding to comment type
            Color.yellow.opacity(0.2)
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
                            Text("This is yellow comment")
                                .font(.body)
                                .padding(16)
                            Spacer(minLength: 0)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: 345, alignment: .trailing)
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
    CommentView()
}
