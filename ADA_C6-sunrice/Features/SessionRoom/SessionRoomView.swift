//
//  SessionRoomView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 10/11/25.
//

import SwiftUI

struct SessionRoomView: View {
    let id: Int64
    
    @State private var messages: [String] = []
    @State private var inputText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Messages area
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .trailing, spacing: 8) {
                        ForEach(Array(messages.enumerated()), id: \.offset) { index, message in
                            IdeaBubbleView(text: message, ideaId: 1)
                                .id(index)
                        }
                    }
                    .padding(.vertical, 8)
                }
                .onChange(of: messages.count, initial: true) { _, _ in
                    if let lastIndex = messages.indices.last {
                        withAnimation {
                            proxy.scrollTo(lastIndex, anchor: .bottom)
                        }
                    }
                }
            }
            
            // Input area
            HStack(spacing: 12) {
                TextField("Type an idea...", text: $inputText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .lineLimit(1...5)
                    .focused($isTextFieldFocused)
                    .onSubmit {
                        sendMessage()
                    }
                
                Button(action: sendMessage) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 28))
                        .foregroundColor(inputText.isEmpty ? Color.gray : Color.blue)
                }
                .disabled(inputText.isEmpty)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(.systemBackground))
        }
//        .background(Color(.systemGroupedBackground))
    }
    
    private func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            messages.append(trimmedText)
            inputText = ""
            isTextFieldFocused = false
        }
        
        Task {
            let newIdea = Idea(
                id: 0, // pakai 0 karena tidak bisa nil. nanti akan di-override di supabase
                text: trimmedText,
                type: 1,
                session_id: id
            )
            do {
                try await insertIdea(newIdea)
            } catch {
                print("Error inserting idea: \(error)")
            }
        }
    }
}

#Preview {
    SessionRoomView(id: 1)
}
