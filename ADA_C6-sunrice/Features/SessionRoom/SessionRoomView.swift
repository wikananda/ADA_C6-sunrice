//
//  SessionRoomView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 10/11/25.
//

import SwiftUI

struct SessionRoomView: View {
    @Environment(\.dismiss) private var dismiss

    @StateObject private var vm: SessionRoomViewModel

    init(id: Int64, isHost: Bool = false) {
        _vm = .init(wrappedValue: .init(id: id, isHost: isHost))
    }

    @FocusState private var isTextFieldFocused: Bool

    var body: some View {
        if vm.isLoading {
            ProgressView("Loading session...")
        } else {
            sessionContent
        }
    }
    
    private var sessionContent: some View {
        ZStack(alignment: .bottom) {
            VStack(alignment: .leading, spacing: 8) {
                Header(
                    config: .init(
                        title: vm.roomType.shared.title,
                        trailing: .timer(date: vm.deadline)
                    ),
                    onBack: { dismiss() }
                )
                .padding(.horizontal)
                .padding(.bottom, 4)

                // Prompt
                RoomPrompt(title: vm.prompt)

                // Messages area
                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(alignment: .trailing, spacing: 8) {
                            // Show ideas from previous rounds (from all users)
                            ForEach(vm.serverIdeas) { idea in
                                 let isGreenIdea = idea.type_id == vm.getGreenTypeId()
                                 let showPlus = vm.isCommentRound && isGreenIdea
                                 
                                 let counts = vm.commentCounts[idea.id] ?? (yellow: 0, black: 0, darkGreen: 0)
                                 
                                 IdeaBubbleView(
                                     text: idea.text ?? "",
                                     type: vm.getMessageCardType(for: idea.type_id),
                                     ideaId: Int(idea.id),
                                     yellowMessages: counts.yellow,
                                     blackMessages: counts.black,
                                     darkGreenMessages: counts.darkGreen,
                                     showPlusButton: showPlus,
                                     onTapPlus: { _ in
                                         vm.openCommentSheet(for: idea)
                                     }
                                 )
                                 .padding(.horizontal, 16)
                            }
                            
                            // Show current round's local ideas (not yet uploaded)
                            ForEach(Array(vm.localIdeas.enumerated()), id: \.offset) { index, localIdea in
                                IdeaBubbleView(
                                    text: localIdea.text,
                                    type: vm.roomType.shared.type,
                                    ideaId: index
                                )
                                .padding(.horizontal, 16)
                                .id("local-\(index)")
                            }
                            
                            Color.clear
                                .frame(maxWidth: .infinity)
                                .frame(height: 125)
                        }
                        .padding(.vertical, 8)
                    }
                    .onTapGesture {
                        UIApplication.shared.endEditing()
                    }
                    .onChange(of: vm.localIdeas.count, initial: true) { _, _ in
                        // Scroll to last local idea when new one is added
                        if !vm.localIdeas.isEmpty {
                            withAnimation {
                                proxy.scrollTo("local-\(vm.localIdeas.count - 1)", anchor: .bottom)
                            }
                        }
                    }
                }
            }

            VStack(alignment: .trailing, spacing: 0) {
                // Time extension button
                MoreTimeButton(
                    isHost: vm.isHost,
                    action: vm.onTapExtensionButton
                )

                // Input area - only show in non-comment rounds
                if !vm.isCommentRound {
                    InputArea(inputText: $vm.inputText, action: vm.sendMessage)
                } else {
                    // In comment rounds, show instruction to tap plus button
                    HStack {
                        Image(systemName: "info.circle")
                        Text("Tap the + button on ideas to add comments")
                            .font(.bodySM)
                    }
                    .foregroundColor(AppColor.Primary.gray)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(AppColor.blue10)
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        .onTapToDismissKeyboard()
        .overlay(alignment: .center) {
            if vm.showInstruction {
                InstructionCard(
                    instruction: vm.roomType.shared.instruction,
                    onTap: vm.closeInstruction
                )
            }
            // TODO: finish logic; implement current & total players
//            if vm.showIntroduction {
//                SessionIntroductionView(introduction: vm.roomType.shared.introduction)
//            }
            if vm.isTimeUp {
                TimesUpView()
            }
        }
        .fullScreenCover(isPresented: $vm.showRoundSummary) {
            RoundSummaryView(vm: vm)
        }
        .sheet(isPresented: $vm.showCommentSheet) {
            CommentSheetView(vm: vm)
        }
    }
}

#Preview {
    SessionRoomView(id: 1)
}
