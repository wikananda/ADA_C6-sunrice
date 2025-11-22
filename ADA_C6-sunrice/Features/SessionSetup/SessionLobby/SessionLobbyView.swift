//
//  RoomLobbyView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 03/11/25.
//

import SwiftUI

struct SessionLobbyView: View {
    var participants: [String] = ["Saskia", "Wikan", "Selena", "Hendy", "Richard"]
    var code: String = "244831"
    var selectedPreset: SessionPreset
    var topic: String
    var description: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal) {
                LazyHStack (spacing: 16) {
                    ForEach(participants, id: \.self) { name in
                        ParticipantBadge(name: name)
                    }
                }
                .frame(maxHeight: 64)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 8) {
                Text("Your session space is ready")
                    .font(.titleSM)
                Text("popopo")
                    .font(.bodySM)
            }
            .foregroundColor(AppColor.Primary.gray)
            
            Text("Share the session code below so others can join.")
                .font(.bodySM)
                .italic()
                .foregroundColor(AppColor.Primary.gray)
            
            // Code
            SessionCode(code: code)
            
            // Chosen preset
            SelectedPreset(
                title: "Initial Ideas",
                description: "A short, balanced rhythm for fast reflection.",
                showStats: true,
                duration: "30 min",
                numOfRounds: 6,
                sequence: ["w", "g", "g", "y", "b", "r"]
            )
            
            // Session title
            StaticBoxField(
                title: "Session Title",
                description: "How might we make onboarding more delightful?",
                isSelected: true
            )
            
            // Additional description
            StaticBoxField(
                title: "Additional Description",
                description: "Let’s find creative ways to boost user engagement without adding extra steps.",
                isSelected: true
            )
        }
    }
}

#Preview {
    var topic: String = "Initial Ideas"
    var description: String? = "A short, balanced rhythm for fast reflection."
    var selectedPreset = SessionPreset(
        id: 2,
        title: "Initial Ideas",
        description: "A short, balanced rhythm for fast reflection",
        duration: "30 min",
        numOfRounds: 6,
        sequence: ["w", "g", "g", "y", "b", "r"],
        overview: "A complete ideation journey — from understanding the facts to exploring ideas, spotting opportunities, and reflecting on their impact.",
        bestFor: ["Workshops", "Brainstorms", "Early exploration"],
        outcome: "A well-rounded view of the topic — clear facts, expanded ideas, bright opportunities, grounded risks, and emotional perspectives."
    )
    
    SessionLobbyView(selectedPreset: selectedPreset, topic: topic, description: description)
}
