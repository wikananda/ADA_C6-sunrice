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
                            navVM.goToCreateRoom()
                        }
                        .asPrimary()
                        
                        RoomButton(title: "JOIN SESSION", icon: "ipad.and.arrow.forward") {
                            navVM.goToJoinRoom()
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
                    EntryRoomView(mode: .create).environmentObject(navVM)
                case .join:
                    EntryRoomView(mode: .join).environmentObject(navVM)
                case .room(id: let id, name: let name):
//                    RoomLobbyView(id: id, name: name)
                    SessionLobbyView()
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
