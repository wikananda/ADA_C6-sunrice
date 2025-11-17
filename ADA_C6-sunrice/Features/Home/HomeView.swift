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
                Button(action: { navVM.goToCreateSession() }) {
                    Text("Create session")
                        .frame(maxWidth: .infinity)
                }
                .primaryButton()
                Button(action: { navVM.goToJoinSession() }) {
                    Text("Join session")
                        .frame(maxWidth: .infinity)
                }
                .secondaryButton()
            }
            .padding()
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .create:
                    EntrySessionView(mode: .create).environmentObject(navVM)
                case .join:
                    EntrySessionView(mode: .join).environmentObject(navVM)
                case let .session(id):
//                    SessionLobbyView(id: id)
                    Text("Bentar dulu")
                case .comment(let ideaId):
//                    CommentView(ideaId: ideaId)
                    Text("Bentar dulu")
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
