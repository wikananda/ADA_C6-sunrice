//
//  IdeaSummaryCard.swift
//  ADA_C6-sunrice
//
//  Created by Saskia on 25/11/25.
//

//import SwiftUI
//
///// 3-level rating based on benefits vs risks
//enum IdeaRating {
//    case neutral
//    case good
//    case risky
//    
//    var label: String {
//        switch self {
//        case .neutral: return "Neutral"
//        case .good:    return "Good"
//        case .risky:   return "Risky"
//        }
//    }
//    
//    var pillBackground: Color {
//        switch self {
//        case .neutral:
//            return Color.whiteishBlue10
//        case .good:
//            return Color.green10
//        case .risky:
//            return Color.red10
//        }
//    }
//    
//    var pillTextColor: Color {
//        switch self {
//        case .neutral:
//            return Color.grayscale60
//        case .good:
//            return Color.green50
//        case .risky:
//            return Color.red
//        }
//    }
//}
//
//struct IdeaSummaryCard: View {
//    let ideaText: String
//    let commentCounts: CommentCounts?   // uses yellow = benefits, black = risks
//    
//    var body: some View {
//        HStack(spacing: 0) {
//            // LEFT GREEN BOOKMARK
//            Rectangle()
//                .fill(Color.green50)
//                .frame(width: 16)
//                .frame(maxHeight: .infinity)
//            
//            // CONTENT
//            VStack(alignment: .leading, spacing: 8) {
//                // Top row: idea text + chevron
//                HStack(alignment: .center, spacing: 8) {
//                    Text(ideaText)
//                        .font(Font.custom("SF Pro", size: 12))
//                        .foregroundColor(Color.grayscale60)
//                        .frame(alignment: .leading)
//                    
//                    Image(systemName: "chevron.right")
//                        .font(.system(size: 16, weight: .semibold))
//                        .foregroundColor(.secondary)
//                    
//                }
//                
//                
//                // Bottom row: Rating label + pill
//                HStack(spacing: 6) {
//                    Text("Rating:")
//                        .font(.system(size: 11, weight: .semibold))
//                        .foregroundColor(Color.grayscale50)
//
//                    ratingPill(for: rating)
//                    
//                    Spacer(minLength: 0)
//                }
//            }
//            .padding(16)
//        }
//        .background(Color(red: 0.99, green: 0.99, blue: 0.99))
//        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
//        .overlay(
//            RoundedRectangle(cornerRadius: 20, style: .continuous)
//                .stroke(Color.grayscale20, lineWidth: 1)
//        )
//    }
//    
//    // MARK: - Rating logic
//    
//    /// Rating rule:
//    /// - if no benefits/risks or equal → neutral
//    /// - if benefits > risks → good
//    /// - if risks > benefits → risky
//    private var rating: IdeaRating {
//        guard let counts = commentCounts else { return .neutral }
//        
//        let benefits = counts.yellow
//        let risks = counts.black
//        
//        if (benefits == 0 && risks == 0) || benefits == risks {
//            return .neutral
//        } else if benefits > risks {
//            return .good
//        } else {
//            return .risky
//        }
//    }
//    
//    @ViewBuilder
//    private func ratingPill(for rating: IdeaRating) -> some View {
//        Text(rating.label)
//            .font(.system(size: 11, weight: .medium))
//            .padding(.horizontal, 8)
//            .padding(.vertical, 4)
//            .background(rating.pillBackground)
//            .foregroundColor(rating.pillTextColor)
//            .cornerRadius(4)
//    }
//}
//
//// MARK: - Preview
//
//struct IdeaSummaryCard_Previews: PreviewProvider {
//    static var previews: some View {
//        IdeaSummaryCard(
//            ideaText: "Short videos within categorised playlist on ADA essential informations",
//            commentCounts: CommentCounts(yellow: 0, black: 0, darkGreen: 0)
//        )
//        .padding(16)
//        .previewLayout(.sizeThatFits)
//    }
//}
//

import SwiftUI

/// 3-level rating based on benefits vs risks
enum IdeaRating {
    case neutral
    case good
    case risky
    
    var label: String {
        switch self {
        case .neutral: return "Neutral"
        case .good:    return "Good"
        case .risky:   return "Risky"
        }
    }
    
    var pillBackground: Color {
        switch self {
        case .neutral:
            return Color.whiteishBlue10
        case .good:
            return Color.green10
        case .risky:
            return Color.red10
        }
    }
    
    var pillTextColor: Color {
        switch self {
        case .neutral:
            return Color.whiteishBlue70
        case .good:
            return Color.green50
        case .risky:
            return Color.red
        }
    }
}

struct IdeaSummaryCard: View {
    let ideaText: String
    let commentCounts: CommentCounts?   // uses yellow = benefits, black = risks
    
    var body: some View {
        HStack(spacing: 0) {
            // LEFT GREEN BOOKMARK
            Rectangle()
                .fill(Color.green50)
                .frame(width: 16)
                .frame(maxHeight: .infinity)
            
            // CONTENT
            VStack(alignment: .leading, spacing: 8) {
                // Top: idea text (no chevron here anymore)
                Text(ideaText)
                    .font(Font.custom("SF Pro", size: 12))
                    .foregroundColor(Color.grayscale60)
                    .frame(alignment: .leading)
                    .multilineTextAlignment(.leading)
                
                // Bottom row: Rating label + pill
                HStack(spacing: 6) {
                    Text("Rating:")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundColor(Color.grayscale50)

                    ratingPill(for: rating)
                    
                    Spacer(minLength: 0)
                }
            }
            .padding(16)
        }
        .background(Color.grayscale10)
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.grayscale20, lineWidth: 1)
        )
        // 🔹 Chevron overlay, vertically centered in the card
        .overlay(
            Image(systemName: "chevron.right")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.secondary)
                .padding(.trailing, 16),
            alignment: .trailing
        )
    }
    
    // MARK: - Rating logic
    
    /// Rating rule:
    /// - if no benefits/risks or equal → neutral
    /// - if benefits > risks → good
    /// - if risks > benefits → risky
    private var rating: IdeaRating {
        guard let counts = commentCounts else { return .neutral }
        
        let benefits = counts.yellow
        let risks = counts.black
        
        if (benefits == 0 && risks == 0) || benefits == risks {
            return .neutral
        } else if benefits > risks {
            return .good
        } else {
            return .risky
        }
    }
    
    @ViewBuilder
    private func ratingPill(for rating: IdeaRating) -> some View {
        Text(rating.label)
            .font(.system(size: 11, weight: .medium))
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(rating.pillBackground)
            .foregroundColor(rating.pillTextColor)
            .cornerRadius(4)
    }
}

// MARK: - Preview

struct IdeaSummaryCard_Previews: PreviewProvider {
    static var previews: some View {
        IdeaSummaryCard(
            ideaText: "Short videos within categorised playlist on ADA essential informations",
            commentCounts: CommentCounts(yellow: 0, black: 0, darkGreen: 0)
        )
        .padding(16)
        .previewLayout(.sizeThatFits)
    }
}
 
