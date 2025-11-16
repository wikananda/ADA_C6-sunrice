//
//  TBAPreset.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct TBAPreset: View {
    var title: String?
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("\(title ?? "New Preset")")
                    .font(.titleMD)
                    .foregroundColor(AppColor.grayscale40)
                Text("(Coming soon)")
                    .font(.bodySM)
                    .foregroundStyle(AppColor.grayscale40)
                    .italic(true)
            
            }
            Spacer()
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    AppColor.grayscale20,
                    lineWidth: 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TBAPreset()
}
