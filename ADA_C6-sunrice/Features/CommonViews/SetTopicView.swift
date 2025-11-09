//
//  SetTopicView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 09/11/25.
//
import SwiftUI
import Foundation
import Supabase

struct SetTopicView: View {
    @State private var intention = ""
    @State private var context = ""
    @State private var isIntentionEntered: Bool = false
    @State private var isContextEntered: Bool = false
    
    let title = "Set The Intention!"
    
    var body: some View {
        ZStack {
            BackgroundView()
            VStack(spacing: 16){
                VStack(alignment: .leading) {
                    Text(title)
                    Text("Add Session Topic")
                    TextField("e.g., “How might we make onboarding more delightful?”, “Exploring sustainable packaging ideas.”, etc.", text: $intention
                    )
                    .frame(height: 60)
                    .padding(12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.sRGB, red: 29/255, green: 29/255, blue: 31/255, opacity: 0.1), lineWidth: 6)
                    )
                    .cornerRadius(12)
                }
                
                VStack(alignment: .leading) {
                    Text("Add Context (optional)")
                        .font(.system(size: 16))
                    TextField("e.g, “Let’s find creative ways to boost user engagement without adding extra steps.”, “Looking for story-driven ideas for our next social campaign.”, etc.", text: $context
                    )
                    .frame(height: 143)
                    .padding(12)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.sRGB, red: 29/255, green: 29/255, blue: 31/255, opacity: 0.1), lineWidth: 6)
                    )
                    .cornerRadius(12)
                }
                if !intention.isEmpty {
                    ButtonView()
                        .buttonStyle(PrimaryButtonActive())
                } else {
                    ButtonView()
                        .buttonStyle(PrimaryButtonDisabled())
                }
            }
            .padding(18)
        }
    }
    
}

#Preview {
    SetTopicView()
}

