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
                            ForEach(
                                Array(vm.messages.enumerated()),
                                id: \.offset
                            ) {
                                index,
                                message in
                                IdeaBubbleView(
                                    text: message.text,
                                    type: message.type,
                                    ideaId: 1
                                )
                                .padding(.horizontal, 16)
                                .id(index)
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    .onChange(of: vm.messages.count, initial: true) { _, _ in
                        if let lastIndex = vm.messages.indices.last {
                            withAnimation {
                                proxy.scrollTo(lastIndex, anchor: .bottom)
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

                // Input area
                InputArea(inputText: $vm.inputText, action: vm.sendMessage)
            }
        }
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
    }
}

#Preview {
    SessionRoomView(id: 1)
}
