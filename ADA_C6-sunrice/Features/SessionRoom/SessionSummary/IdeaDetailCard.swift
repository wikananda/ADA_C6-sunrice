//
//  IdeaDetailCard.swift
//  ADA_C6-sunrice
//
//  Created by Saskia on 25/11/25.
//

import SwiftUI

// MARK: - Segments

enum IdeaDetailSegment: String, CaseIterable, Identifiable {
    case benefits
    case risks
    case facts
    
    var id: String { rawValue }
    
    var title: String {
        switch self {
        case .benefits: return "Benefits"
        case .risks:    return "Risks"
        case .facts:    return "Facts & Info"
        }
    }
}

// MARK: - Detail Card

struct IdeaDetailCard: View {
    let ideaText: String
    
    @State private var selectedSegment: IdeaDetailSegment = .benefits
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            
            // Idea text
            Text(ideaText)
                .font(.system(size: 13))
                .foregroundColor(Color(.label))
                .fixedSize(horizontal: false, vertical: true)
            
            // Rating row (static placeholder)
            HStack(spacing: 6) {
                Text("Rating:")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundColor(Color(.secondaryLabel))
                
                Text("Neutral")
                    .font(.system(size: 11, weight: .medium))
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(Color(.systemGray6))
                    .cornerRadius(4)
                
                Spacer()
            }
            
            // Segments (fixed)
            segmentTabs
            
            // Segment content
            segmentContent
        }
        .padding(16)
        .frame(width: 360, alignment: .topLeading)
        .background(AppColor.grayscale10)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(.systemGray4), lineWidth: 1)
        )
    }
    
    // MARK: - Segments bar (underline style)
    
    private var segmentTabs: some View {
        GeometryReader { geo in
            let totalWidth = geo.size.width
            let segmentWidth = totalWidth / 3
            
            VStack(alignment: .leading, spacing: 4) {
                
                // Top row: labels
                HStack(spacing: 0) {
                    ForEach(IdeaDetailSegment.allCases) { segment in
                        let isSelected = (segment == selectedSegment)
                        
                        Button {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedSegment = segment
                            }
                        } label: {
                            Text(segment.title)
                                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                                .foregroundColor(
                                    isSelected
                                    ? AppColor.Primary.blue
                                    : AppColor.grayscale40
                                )
                                .frame(width: segmentWidth, alignment: .leading)
                        }
                        .buttonStyle(.plain)
                    }
                }
                
                // Baseline + underline indicator
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(AppColor.grayscale40)
                        .frame(height: 1)
                    
                    // Blue underline under selected tab
                    Rectangle()
                        .fill(AppColor.Primary.blue)
                        .frame(width: segmentWidth * 0.7, height: 2)
                        .offset(x: underlineOffset(segmentWidth: segmentWidth))
                }
            }
        }
        .frame(height: 32)   // enough height for labels + underline
    }
    
    private func underlineOffset(segmentWidth: CGFloat) -> CGFloat {
        let index: CGFloat
        switch selectedSegment {
        case .benefits: index = 0
        case .risks:    index = 1
        case .facts:    index = 2
        }
        // center the underline roughly under the text
        return index * segmentWidth + segmentWidth * 0
    }
    
    // MARK: - Segment Content
    
    @ViewBuilder
    private var segmentContent: some View {
        switch selectedSegment {
        case .benefits:
            // Uses your existing IdeaBubbleView
            IdeaBubbleView(
                text: "Fun and engaging for the learners (short attention span these days lol)",
                type: .yellow,
                ideaId: 1
            )
        case .risks:
            Text("No risks added yet.")
                .font(.system(size: 12))
                .foregroundColor(Color(.secondaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
        case .facts:
            Text("No facts & info added yet.")
                .font(.system(size: 12))
                .foregroundColor(Color(.secondaryLabel))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

// MARK: - Preview

struct IdeaDetailCard_Previews: PreviewProvider {
    static var previews: some View {
        IdeaDetailCard(
            ideaText: "Short videos within categorised playlist on ADA essential informations"
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
}
