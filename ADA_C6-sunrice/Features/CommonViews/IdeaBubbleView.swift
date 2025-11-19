//
//  IdeaBubbleView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 10/11/25.
//

import SwiftUI

struct IdeaBubbleView: View {
    let text: String
    let type: Color
    let ideaId: Int
    var onTapPlus: (Int) -> Void = { _ in }

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .frame(width: 16)
                .foregroundStyle(type)
            HStack(spacing: 8) {
                Text(text)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)
                if type == .green {
                    Image(systemName: "plus.circle.dashed")
                }
            }
            .padding(16)
        }
        .fixedSize(horizontal: false, vertical: true)
        .clipShape(
            RoundedRectangle(cornerRadius: 20)
        )
        .background(.grayscale10)
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(.grayscale20)
        }
        //        .overlay(alignment: .bottomTrailing) {
        //            BadgeView()
        //                .padding(.trailing, 36)
        //                .padding(.top, 12)
        //        }
    }
}

struct BadgeView: View {
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: "arrow.up.right")
                .font(.caption2)
                .bold()
            Text("2")
                .font(.caption)
                .bold()
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .foregroundColor(.yellow)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(.grayscale10)
        )
    }
}

#Preview {
    IdeaBubbleView(
        text: "Hello! This is a sample idea.",
        type: .green,
        ideaId: 1
    )
    .padding()
}
