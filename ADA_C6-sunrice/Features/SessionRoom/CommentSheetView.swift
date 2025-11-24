//
//  CommentSheetView.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import SwiftUI

struct CommentSheetView: View {
    @ObservedObject var vm: SessionRoomViewModel
    @Environment(\.dismiss) private var dismiss
    @State private var commentText: String = ""
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                // Original Idea
                if let idea = vm.selectedIdeaForComment {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Original Idea")
                            .font(.labelMD)
                            .foregroundColor(AppColor.Primary.gray)
                        
                        IdeaBubbleView(
                            text: idea.text ?? "",
                            type: .green,
                            ideaId: Int(idea.id)
                        )
                    }
                    .padding(.horizontal)
                }
                
                // Comment Input
                VStack(alignment: .leading, spacing: 8) {
                    Text("Your \(vm.roomType.shared.title)")
                        .font(.labelMD)
                        .foregroundColor(AppColor.Primary.gray)
                    
                    BoxField(
                        placeholder: "Type your comment here...",
                        text: $commentText
                    )
                    .focused($isTextFieldFocused)
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Submit Button
                AppButton(title: "Submit") {
                    vm.submitComment(text: commentText)
                    dismiss()
                }
                .disabled(commentText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                .padding(.horizontal)
            }
            .padding(.vertical)
            .navigationTitle("Add Comment")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .onAppear {
                isTextFieldFocused = true
            }
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
            CommentSheetView(vm: vm)
        }
    }
    
    return PreviewWrapper()
}
