//
//  Presets.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 16/11/25.
//

import SwiftUI

enum sequenceColor: String {
    case red="r"
    case yellow="y"
    case green="g"
    case black="b"
    case white="w"
}

struct Presets: View {
    var title: String = "Preset"
    var description: String?
    var duration: String = "30 minutes"
    var numOfRounds: Int = 6
    // Accept sequence as single-letter codes, e.g., ["r", "b", "y"].
    var sequence: [String] = ["w", "g", "g", "y", "b", "r"]
    
    @State private var isSelected: Bool = false
    @State private var isExpanded: Bool = false
    
    // Expansion
    var overview: String?
    var bestFor: [String]? = ["Workshops", "Brainstorms"]
    var outcome: String?

    // Map codes to typed enum and colors
    private var sequenceColors: [sequenceColor] {
        sequence.compactMap { sequenceColor(rawValue: $0.lowercased()) }
    }
    private func color(for code: sequenceColor) -> Color {
        switch code {
        case .red:    return AppColor.Primary.red
        case .yellow: return AppColor.Primary.yellow
        case .green:  return AppColor.Primary.green
        case .black:  return AppColor.grayscale70
        case .white:  return AppColor.grayscale20
        }
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            // Title
            HStack (alignment: .center) {
                Text(title)
                    .font(.titleMD)
                    .foregroundColor(AppColor.Primary.gray)
                Spacer()
                HStack (spacing: 8) {
                    if isSelected {
                        Text("Selected")
                            .font(.labelTiny)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 4)
                            .background(AppColor.Primary.blue)
                            .foregroundColor(AppColor.grayscale10)
                            .clipShape(Capsule())
                    }
                    Button(action: {
                        withAnimation(.spring(
                            duration: 0.35,
                            bounce: 0.35,
                            blendDuration: 0.35)
                        ) {isExpanded.toggle()}
                    }) {
                        Image(systemName: (isExpanded ? "chevron.up" :"chevron.down"))
                            .font(.labelMD)
                            .foregroundColor(AppColor.Primary.gray)
                    }
                    .frame(maxWidth: 24, maxHeight: 24)
                }
            }
            
            // Stats info
            HStack {
                Image(systemName: "clock")
                Text("~\(duration)")
                Text("•")
                Text("\(sequenceColors.isEmpty ? numOfRounds : sequenceColors.count) rounds")
            }
            .foregroundColor(AppColor.Primary.gray)
            
            // Description
            Text("\(description ?? "Description")")
            
            // Sequences
            HStack {
                ForEach(Array(sequenceColors.enumerated()), id: \.offset) { idx, code in
                    Circle()
                        .fill(color(for: code))
                        .frame(width: 18, height: 18)
                    
                    if idx < sequenceColors.count - 1 {
                        Image(systemName: "arrow.right")
                        
                    }
                }
            }
            
            // Expansions
            if isExpanded {
                VStack (alignment: .leading, spacing: 6) {
                    Text("Overview:")
                        .font(.labelMD)
                    Text("\(overview ?? "No overview provided.")")
                }
                
                VStack (alignment: .leading, spacing: 6) {
                    Text("Best for:")
                        .font(.labelMD)
                    ForEach(bestFor ?? [], id: \.self) { application in
                        Text("•  \(application)")
                    }
                }
                
                VStack (alignment: .leading, spacing: 6) {
                    Text("Outcome:")
                        .font(.labelMD)
                    Text("\(outcome ?? "No outcome provided.")")
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(isSelected ? AppColor.whiteishBlue10 : .white)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    isSelected ? AppColor.Primary.blue : AppColor.grayscale20,
                    lineWidth: isSelected ? 2 : 1)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            withAnimation(.linear(duration: 0.1)) {
                isSelected.toggle()
            }
        }
    }
}

#Preview {
    Presets()
}
