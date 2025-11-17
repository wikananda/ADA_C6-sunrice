//
//  CommentBubbleView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 16/11/25.
//
import SwiftUI

struct CommentView: View {
    let ideaId: Int
    
    @State private var comments: [String] = []
    @State private var inputText: String = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        VStack(spacing: 0) {

            // eg. Build idea
            Text("Comments for this Idea")
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(alignment: .leading, spacing: 6) {
                        ForEach(comments, id: \.self) { comment in
                            CommentBubble(text: comment)
                        }
                    }
                    .padding(.horizontal)
                }
            }

            Divider()

            // Input bar
            HStack {
                TextField("Add a comment...", text: $inputText)
                    .textFieldStyle(.roundedBorder)
                    .focused($isFocused)

                Button {
                    guard !inputText.isEmpty else { return }
                    comments.append(inputText)
                    inputText = ""
                } label: {
                    Image(systemName: "paperplane.fill")
                }
            }
            .padding()
        }
        .navigationTitle("Comment")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct CommentBubble: View {
    let text: String

    var body: some View {
        HStack {
            Text(text)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

#Preview {
    CommentView(ideaId: 1)
}
