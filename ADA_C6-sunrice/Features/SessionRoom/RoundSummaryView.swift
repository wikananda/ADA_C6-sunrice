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
                    trailing: .none
                ),
                onBack: { dismiss() }
            )
            .padding(.horizontal)
            
            // Prompt
            RoomPrompt(title: vm.prompt)
            
            // Ideas List
            ScrollView {
                LazyVStack(alignment: .trailing, spacing: 8) {
                    // Show green ideas if in comment round, otherwise show current round ideas
                    let ideasToShow = vm.isCommentRound ? vm.serverIdeas.filter { idea in
                        // Filter for green ideas only
                        guard let typeId = idea.type_id else { return false }
                        return typeId == vm.getGreenTypeId()
                    } : vm.serverIdeas
                    
                    ForEach(ideasToShow) { idea in
                        let counts = vm.commentCounts[idea.id] ?? (yellow: 0, black: 0, darkGreen: 0)
                        
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
                        .padding(.horizontal, 16)
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
                .frame(maxWidth: .infinity)
                .padding()
                .background(AppColor.blue10)
                .cornerRadius(12)
                .padding(.horizontal)
            }
        }
        .background(
            Background()
        )
        .onAppear {
            Task {
                await vm.fetchCommentCounts()
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
