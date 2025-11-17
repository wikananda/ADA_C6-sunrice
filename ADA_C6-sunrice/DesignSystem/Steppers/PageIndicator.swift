//
//  PageIndicator.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 16/11/25.
//

import SwiftUI

struct PageIndicator: View {
    var totalPages: Int = 3
    @Binding var currentPage: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<totalPages, id: \.self) { idx in
                if idx == currentPage {
                    Capsule()
                        .fill(AppColor.Primary.gray)
                        .frame(width: 24, height: 8)
                } else {
                    Circle()
                        .fill(AppColor.grayscale30)
                        .frame(width: 8, height: 8)
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var page: Int = 0
    PageIndicator(currentPage: $page)
}
