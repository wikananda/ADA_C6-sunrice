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
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal) {
                LazyHStack (spacing: 32) {
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
                sequence: ["w", "g", "g", "y", "b", "r"],
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
    SessionLobbyView()
}
