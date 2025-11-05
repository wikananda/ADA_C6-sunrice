//
//  CreateRoomView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftUI

enum EntryMode { case create, join }

struct EntryRoomView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    
    @State var mode: EntryMode = .join
    @State private var username: String = ""
    @State private var code: String = ""
    
    var body: some View {
        VStack(spacing: 28) {
            switch mode {
                case .create:
                    CreateRoomView(username: $username, onStart: {navVM.goToRoomLobby(id: "")})
                case .join:
                JoinRoomView(username: $username, code: $code, onJoin: {navVM.goToRoomLobby(id: "")})
            }
        }
        .padding(48)
    }
    
}

struct CreateRoomView: View {
    @Binding var username: String
    var onStart: () -> Void = {}
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 128, height: 128)
            .foregroundColor(Color.gray)
        TextField("Enter your name", text: $username)
        Button(action: onStart) {
            Text("Start")
                .frame(maxWidth: .infinity)
        }
        .primaryButton()
    }
}

struct JoinRoomView: View {
    @Binding var username: String
    @Binding var code: String
    var onJoin: () -> Void = {}
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 128, height: 128)
            .foregroundColor(Color.gray)
        TextField("Enter your name", text: $username)
        TextField("Enter room code", text: $code)
            .keyboardType(.numberPad)
        Button(action: onJoin) {
            Text("Join")
                .frame(maxWidth: .infinity)
        }
        .primaryButton()
    }
}

#Preview {
    EntryRoomView()
}
