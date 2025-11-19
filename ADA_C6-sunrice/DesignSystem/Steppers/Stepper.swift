//
//  Stepper.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 16/11/25.
//

import SwiftUI

struct Stepper: View {
    let totalSteps: Int
    let currentSteps: Int
    var horizontalPadding: CGFloat = 12
    
    private var progress: CGFloat {
        guard totalSteps > 1 else { return 0 }
        return CGFloat(currentSteps - 1) / CGFloat(totalSteps - 1)
    }
    
    var body: some View {
        GeometryReader { geo in
            // Keep bars and nodes within the same padded width
            let availableWidth = max(0, geo.size.width - horizontalPadding * 2)
            let clampedProgress = max(0, min(1, progress))
            
            ZStack {
                // Connector line (background + progress) sized to available width
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(AppColor.blue10)
                        .frame(width: availableWidth, height: 6)
                    
                    Capsule()
                        .fill(AppColor.Primary.blue)
                        .frame(
                            width: availableWidth * clampedProgress,
                            height: 6
                        )
                        .animation(.easeInOut(duration: 0.25), value: clampedProgress)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                // Nodes (share same padded layout as the connector)
                HStack {
                    ForEach(1...totalSteps, id: \.self) { step in
                        Node(for: step)
                        if step != totalSteps {
                            Spacer()
                        }
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 24)
            .padding(.horizontal, horizontalPadding)
        }
    }
    
    private func Node(for step: Int) -> some View {
        let isCompleted: Bool = step < currentSteps
        
        return ZStack {
            Circle()
                .strokeBorder(AppColor.Primary.blue, lineWidth: 1)
                .background(
                    Circle()
                        .foregroundColor(isCompleted ? AppColor.Primary.blue : AppColor.grayscale10)
                )
            Text("\(step)")
                .font(.bodySMEmphasis)
                .foregroundStyle(isCompleted ? AppColor.grayscale10 : AppColor.Primary.blue)
        }
        .frame(width: 24, height: 24)
    }
    
}

#Preview {
    Stepper(totalSteps: 3, currentSteps: 2)
}
