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
                                
                                // Notes
                                if let notes = summary.notes, !notes.isEmpty {
                                    Text(notes)
                                        .font(.bodySM)
                                        .foregroundColor(AppColor.Primary.gray)
                                }
                                
                                // Themes
                                ForEach(summary.themes, id: \.name) { theme in
                                    VStack(alignment: .leading, spacing: 8) {
                                        Text(theme.name)
                                            .font(.bodySM)
                                            .foregroundColor(AppColor.Primary.gray)
                                            .bold()
                                        
                                        Text(theme.summary)
                                            .font(.bodySM)
                                            .foregroundColor(AppColor.Primary.gray)
                                    }
                                    .padding()
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .background(AppColor.whiteishBlue50)
                                    .cornerRadius(12)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
                
                LazyVStack(alignment: .leading, spacing: 8) {
                    Text("All Inputs")
                        .font(.titleSM)
                        .foregroundColor(AppColor.Primary.gray)
                        .padding(.horizontal)
                    // Show green ideas if in comment round, otherwise show current round ideas
                    let ideasToShow = vm.isCommentRound ? vm.serverIdeas.filter { idea in
                        // Filter for green ideas only
                        guard let typeId = idea.type_id else { return false }
                        return typeId == vm.getGreenTypeId()
                    } : vm.serverIdeas
                    
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
                        ForEach(Array(ideasToShow)) { idea in
                            let counts = vm.commentCounts[idea.id] ?? CommentCounts(yellow: 0, black: 0, darkGreen: 0)
                            
                            VStack(alignment: .trailing, spacing: 8) {
                                // Green idea bubble
                                IdeaBubbleView(
                                    text: idea.text ?? "",
                                    type: vm.isCommentRound ? .green : vm.roomType.shared.type,
                                    ideaId: Int(idea.id),
                                    yellowMessages: counts.yellow,
                                    blackMessages: counts.black,
                                    darkGreenMessages: counts.darkGreen,
                                    showPlusButton: vm.isCommentRound,
                                    onTapPlus: { _ in
                                        vm.openCommentSheet(for: idea)
                                    }
                                )
                            }
                            .padding(.horizontal, 16)
                        }
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
