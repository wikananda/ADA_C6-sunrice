//
//  RoomLobbyView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 03/11/25.
//

import SwiftUI

struct SessionLobbyView: View {
    let session: SessionDTO
    let mode: ModeDTO?
    let participants: [UserDTO]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            ScrollView(.horizontal) {
                LazyHStack (spacing: 16) {
                    ForEach(participants, id: \.id) { user in
                        ParticipantBadge(name: user.name ?? "user")
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
            SessionCode(code: session.token ?? "------")
            
            // Chosen preset
            SelectedPreset(
                title: mode?.title ?? mode?.name ?? "Preset",
                description: mode?.description ?? "Preset details",
                showStats: true,
                duration: mode?.duration ?? "\(mode?.num_of_rounds ?? mode?.round_count ?? 0) rounds",
                numOfRounds: Int(mode?.num_of_rounds ?? mode?.round_count ?? 0),
                sequence: mode?.sequence ?? []
            )
            
            // Session title
            StaticBoxField(
                title: "Session Title",
                description: session.topic ?? "-",
                isSelected: true
            )
            
            // Additional description
            StaticBoxField(
                title: "Additional Description",
                description: session.description ?? "-",
                isSelected: true
            )
        }
    }
}

#Preview {
    let session = SessionDTO(
        id: 1,
        duration_per_round: "5",
        topic: "How might we make onboarding more delightful?",
        description: "Let’s find creative ways to boost user engagement without adding extra steps.",
        token: "244831",
        is_token_expired: false,
        started_at: nil,
        ended_at: nil,
        created_at: Date(),
        mode_id: 1
    )
    let mode = ModeDTO(
        id: 1,
        name: "Quick Feedback",
        created_at: nil,
        round_count: 3,
        title: "Quick Feedback",
        description: "A short, balanced rhythm for fast reflection",
        duration: "30 min",
        num_of_rounds: 3,
        sequence: ["y", "b", "r"],
        overview: nil,
        best_for: nil,
        outcome: nil
    )
    let participants = [
        UserDTO(id: 1, name: "Saskia", status: 1, created_at: nil),
        UserDTO(id: 2, name: "Selena", status: 1, created_at: nil)
    ]
    SessionLobbyView(session: session, mode: mode, participants: participants)
}
