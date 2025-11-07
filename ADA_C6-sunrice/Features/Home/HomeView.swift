//
//  ContentView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 27/10/25.
//
import SwiftUI

struct HomeView: View {
    @StateObject var navVM = NavigationViewModel()
    
    var body: some View {
        NavigationStack(path: $navVM.path) {
            VStack(spacing: 20) {
                Button(action: { navVM.goToCreateRoom() }) {
                    Text("Create room")
                        .frame(maxWidth: .infinity)
                }
                .primaryButton()
                Button(action: { navVM.goToJoinRoom() }) {
                    Text("Join room")
                        .frame(maxWidth: .infinity)
                }
                .secondaryButton()
            }
            .padding()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .create:
                    EntryRoomView(mode: .create).environmentObject(navVM)
                case .join:
                    EntryRoomView(mode: .join).environmentObject(navVM)
                case .room(id: let id, name: let name):
                    RoomLobbyView(id: id, name: name)
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
