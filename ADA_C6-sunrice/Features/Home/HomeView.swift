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
            ZStack {
                // Background
                Background()
                
                VStack(alignment: .center, spacing: 20) {
                    // Title
                    Text("Think Together, \nOne Color At a Time.")
                        .font(.custom("Manrope", size: 24))
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(AppColor.Primary.gray)
                    
                    // Illustration
                    Image(.group4)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 200)
                    
                    // Buttons
                    VStack(spacing: 16) {
                        RoomButton(title: "CREATE SESSION", icon: "plus.rectangle.portrait") {
                            navVM.goToCreateSession()
                        }
                        .asPrimary()
                        
                        RoomButton(title: "JOIN SESSION", icon: "ipad.and.arrow.forward") {
                            navVM.goToJoinSession()
                        }
                        
                        RoomButton(title: "PAST SESSIONS", icon: "clock.arrow.trianglehead.counterclockwise.rotate.90") {
                            
                        }
                    }
                }
                .padding(24)
            }
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .create:
                    CreateSessionView()
                        .environmentObject(navVM)
                        .toolbar(.hidden, for: .navigationBar)
                case .join:
                    JoinSessionView()
                        .environmentObject(navVM)
                        .toolbar(.hidden, for: .navigationBar)
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
