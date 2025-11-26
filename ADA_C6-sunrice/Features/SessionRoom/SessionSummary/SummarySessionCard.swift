//
//  SummarySessionCard.swift
//  ADA_C6-sunrice
//
//  Created by Saskia on 25/11/25.
//

import SwiftUI

// MARK: - LIVE VIEW

/// Summary card shown at the end of the session.
/// Uses real data from IdeaManager + RoundManager.
struct SummarySessionCard: View {
    @ObservedObject var ideaManager: IdeaManager
    let roundManager: RoundManager
    let sessionId: Int64
    
    /// Optional summary paragraph shown at the top of the card.
    var summaryText: String = ""
    
    @State private var didLoad = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            
            // Summary paragraph
            if !summaryText.isEmpty {
                Text(summaryText)
                    .font(.system(size: 12))
                    .foregroundColor(.primary)
                    .fixedSize(horizontal: false, vertical: true)
            }
            
            // "Ideas:" title
            Text("Ideas:")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            // List of green-round ideas
            VStack(spacing: 16) {
                ForEach(greenIdeas, id: \.id) { idea in
                    IdeaSummaryCard(
                        ideaText: idea.text ?? "",
                        commentCounts: ideaManager.commentCounts[idea.id]
                    )
                }
            }
        }
        .padding(16)
        .frame(width: 360, alignment: .topLeading)
        .background(Color.grayscale10)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(Color.grayscale20, lineWidth: 1)
        )
        .task {
            guard !didLoad else { return }
            didLoad = true
            await loadSummaryData()
        }
    }
    
    // MARK: - Data helpers (same logic as before)
    
    /// Only ideas from the green (idea) round are shown.
    private var greenIdeas: [IdeaDTO] {
        if let greenId = roundManager.getGreenTypeId() {
            return ideaManager.serverIdeas.filter { $0.type_id == greenId }
        } else {
            return ideaManager.serverIdeas
        }
    }
    
    /// Fetches ideas + comment counts (benefit/risk/build-on) from backend.
    private func loadSummaryData() async {
        do {
            try await ideaManager.fetchIdeas(
                sessionId: sessionId,
                typeId: roundManager.getGreenTypeId()
            )
            try await ideaManager.fetchCommentCounts(roundManager: roundManager)
            try await ideaManager.fetchComments(roundManager: roundManager)
        } catch {
            print("⚠️ Failed to load summary data: \(error)")
        }
    }
}


// MARK: - PREVIEW SUPPORT (UI-only, no backend)

// Simple local model just for preview
private struct FakeIdea: Identifiable {
    let id = UUID()
    let text: String
    let counts: CommentCounts
}

/// A static version of the card used only for previewing the UI.
/// It recreates the same layout as `SummarySessionCard` but with local data.
private struct SummarySessionCardPreviewContent: View {
    private let summaryText: String =
    """
    Learners are mostly new to the academy, unfamiliar with CBL and app development. Many don't know what to expect, what they want to learn, or their desired role.

    Challenges include team dynamics and varied mentor styles. There's a desire for clear guidance and community support. Learners are confused and sometimes feel rushed, but value the positive learning environment.
    """
    
    private let ideas: [FakeIdea] = [
        FakeIdea(
            text: "Short videos within categorised playlist on ADA essential informations",
            counts: CommentCounts(yellow: 0, black: 0, darkGreen: 0)   // Neutral
        ),
        FakeIdea(
            text: "Guidebook on who's who and their expertise and how they can help",
            counts: CommentCounts(yellow: 1, black: 3, darkGreen: 0)   // Risky
        ),
        FakeIdea(
            text: "Make some material they could read to prepare a bit on how to get into CBL process",
            counts: CommentCounts(yellow: 4, black: 1, darkGreen: 0)   // Good
        )
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text(summaryText)
                .font(.system(size: 12))
                .foregroundColor(.primary)
                .fixedSize(horizontal: false, vertical: true)
            
            Text("Ideas:")
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.primary)
            
            VStack(spacing: 16) {
                ForEach(ideas) { idea in
                    IdeaSummaryCard(
                        ideaText: idea.text,
                        commentCounts: idea.counts
                    )
                }
            }
        }
        .padding(16)
        .frame(width: 360, alignment: .topLeading)
        .background(Color.grayscale10)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .inset(by: 0.5)
                .stroke(Color.grayscale20, lineWidth: 1)
        )
    }
}


// MARK: - PreviewProvider

struct SummarySessionCard_Previews: PreviewProvider {
    static var previews: some View {
        ScrollView {
            SummarySessionCardPreviewContent()
                .padding(.vertical, 40)
        }
        .previewLayout(.sizeThatFits)
    }
}
