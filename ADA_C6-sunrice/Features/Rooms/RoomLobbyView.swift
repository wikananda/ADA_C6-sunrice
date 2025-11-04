//
//  RoomLobbyView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 03/11/25.
//

import SwiftUI

struct RoomLobbyView: View {
    var id: String = ""
    var body: some View {
        VStack {
            Text("roomName")
            ScrollView(.horizontal) {
                LazyHStack (spacing: 28) {
                    ParticipantCircle()
                }
            }
            
            Spacer()
            Button(action: {}) {
                Text("Start session")
                    .primaryButton()
            }
        }
        .padding()
    }
}

struct ParticipantCircle: View {
    var name: String = "Add"
    var body: some View {
        VStack (spacing: 12) {
            Image(systemName: "person.crop.circle.fill.badge.plus")
                .resizable()
                .scaledToFit()
                .frame(height: 50)
            Text(name)
        }
    }
}

#Preview {
    RoomLobbyView()
}
