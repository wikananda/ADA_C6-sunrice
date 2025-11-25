//
//  RoundSummaryView.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import SwiftUI

struct RoundSummaryView: View {
    @ObservedObject var vm: SessionRoomViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 16) {
                // Header
                Header(
                    config: .init(
                        title: vm.roomType.shared.title,
                        showsBackButton: false,
                        trailing: .none
                    ),
                    //                onBack: { dismiss() }
                )
                .padding(.horizontal)
                
                // Prompt
                RoomPrompt(title: vm.prompt)
                
                // Ideas List
                ScrollView {
                    // AI Summary Section (for white, green, red rounds)
                    if !vm.isCommentRound {
                        VStack(alignment: .leading, spacing: 12) {
                            if vm.isLoadingSummary {
                                HStack(spacing: 12) {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle())
                                    Text("Extracting AI summary...")
                                        .font(.bodySM)
                                        .foregroundColor(AppColor.Primary.gray)
                                }
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(AppColor.blue10)
                                .cornerRadius(12)
                                .padding(.horizontal)
                            } else if let summary = vm.summary {
                                VStack(alignment: .leading, spacing: 12) {
                                    Text("AI Summary")
                                        .font(.titleSM)
                                        .foregroundColor(AppColor.Primary.gray)
                                        .padding(.horizontal)
                                    
                                    // Notes
                                    if let notes = summary.notes, !notes.isEmpty {
                                        Text(notes)
                                            .font(.bodySM)
                                            .foregroundColor(AppColor.Primary.gray)
                                            .padding(.horizontal)
                                    }
                                    
                                    // Insight Categories using the new card view
                                    let categories = summary.themes.map { theme in
                                        InsightCategory(
                                            title: theme.name,
                                            body: theme.summary,
                                            sources: theme.items?.map { $0.input } ?? []
                                        )
                                    }
                                    
                                    InsightCategoryListCard(items: categories)
                                }
                            }
                        }
                    }
                    
                    LazyVStack(alignment: .leading, spacing: 8) {
                        // Show green ideas if in comment round, otherwise show current round ideas
                        
                        // Show comments for this round (in comment rounds)
                        if vm.isCommentRound {
                            let commentsForRound = vm.serverComments.filter { $0.type_id == vm.currentTypeId }
                            ForEach(commentsForRound, id: \.id) { comment in
                                IdeaBubbleView(
                                    text: comment.text ?? "",
                                    type: vm.getMessageCardType(for: comment.type_id),
                                    ideaId: Int(comment.id)
                                )
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 16)
                            }
                        } else {
                            // Button to navigate to all cards view
                            NavigationLink(destination: AllCardsView(vm: vm)) {
                                ButtonSeeAllCards()
                            }
                            .padding(.horizontal, 16)
                            .navigationBarBackButtonHidden(true)
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                Spacer()
                
                // Bottom Action
                if vm.isHost {
                    // Host: Next Round button
                    AppButton(title: "Next Round") {
                        vm.hostAdvanceToNextRound()
                    }
                    .padding(.horizontal)
                } else {
                    // Guest: Waiting message
                    HStack {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                        Text("Waiting for host to start next round...")
                            .font(.bodySM)
                            .foregroundColor(AppColor.Primary.gray)
                    }
                    .padding()
                    .background(AppColor.blue10)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Background()
            )
            .onAppear {
                Task {
                    // Fetch comment counts
                    await vm.fetchCommentCounts()
                    
                    // If it's a comment round, also fetch the actual comments
                    if vm.isCommentRound {
                        await vm.fetchAllComments()
                    } else {
                        // For non-comment rounds (white, green, red), fetch AI summary
                        await vm.fetchSummary()
                    }
                }
            }
            .padding(.bottom)
        }
    }
}
    
#Preview {
    struct PreviewWrapper: View {
        @StateObject var vm: SessionRoomViewModel
        
        init() {
            _vm = StateObject(wrappedValue: SessionRoomViewModel(id: 1, isHost: true))
        }
        
        var body: some View {
            RoundSummaryView(vm: vm)
        }
    }
    
    return PreviewWrapper()
}

