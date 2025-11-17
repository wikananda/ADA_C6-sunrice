//
//  DurationSelector.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct DurationSelector: View {
    @Binding var minutesPerRound: Int
    let totalRounds: Int = 6
    
    var totalDuration: String {
        "\(minutesPerRound * totalRounds) min"
    }
    
    var body: some View {
        HStack(spacing: 24) {
            // Time Stepper
            VStack(alignment: .leading, spacing: 12) {
                Text("Duration per Round")
                    .font(.labelMD)
                    .foregroundColor(AppColor.Primary.gray)
                
                HStack {
                    Button(action: {minutesPerRound = max(1, minutesPerRound - 1)}) {
                        Image(systemName: "minus")
                            .font(.symbolM)
                            .foregroundColor(AppColor.Primary.gray)
                            .frame(maxWidth: 24, maxHeight: 20)
                    }
                    Spacer()
                    Text("\(minutesPerRound) min")
                        .font(.symbolM)
                        .foregroundColor(AppColor.Primary.gray)
                        .frame(maxWidth: 64, maxHeight: 20)
                    Spacer()
                    Button(action: {minutesPerRound = min(30, minutesPerRound + 1)}) {
                        Image(systemName: "plus")
                            .font(.symbolM)
                            .foregroundColor(AppColor.Primary.gray)
                            .frame(maxWidth: 24, maxHeight: 20)
                    }
                }
                .padding()
                .frame(maxWidth: 156, maxHeight: 36)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            AppColor.grayscale20,
                            lineWidth: 2)
                )
                .contentShape(RoundedRectangle(cornerRadius: 10))
                
            }
            // Total duration
            VStack(alignment: .leading, spacing: 12) {
                Text("Total Duration")
                    .font(.labelMD)
                    .foregroundColor(AppColor.Primary.gray)
                
                Text("~\(totalDuration)")
                    .frame(maxWidth: 114, maxHeight: 36)
                    .font(.symbolM)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(AppColor.whiteishBlue10)
                    )
                    .contentShape(RoundedRectangle(cornerRadius: 10))
            }
        }
    }
}

#Preview {
    @Previewable @State var minutesPerRound: Int = 5
    DurationSelector(minutesPerRound: $minutesPerRound)
}
