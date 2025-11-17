//
//  StaticBoxField.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct StaticBoxField: View {
    var title: String? = "Title"
    var description: String? = "Description"
    var isSelected: Bool = true
    
    var body: some View {
        VStack (alignment: .leading, spacing: 8) {
            Text(title ?? "Title")
                .font(.titleMD)
                .foregroundColor(AppColor.Primary.gray)
            Text(description ?? "Description")
                .font(.bodySM)
                .foregroundColor(AppColor.Primary.gray)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? AppColor.whiteishBlue10 : AppColor.grayscale10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(isSelected ? AppColor.Primary.blue : AppColor.grayscale20, lineWidth: isSelected ? 2 : 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
    }
}

#Preview {
    StaticBoxField()
}
