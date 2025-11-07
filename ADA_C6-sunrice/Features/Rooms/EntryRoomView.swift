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
    @StateObject private var vm = EntryRoomViewModel()
    
    @State var mode: EntryMode = .create
    @State private var username: String = ""
    @State private var roomName: String = ""
    @State private var code: String = ""
    
    var body: some View {
        VStack(spacing: 28) {
            switch mode {
                case .create:
                    CreateRoomView(
                        username: $username,
                        roomName: $roomName,
                        isLoading: vm.isLoading,
                        onStart: { Task { await vm.createRoom(username: username, roomName: roomName) } }
                    )
                case .join:
                JoinRoomView(
                    username: $username,
                    code: $code,
                    isLoading: vm.isLoading,
                    onJoin: { Task { await vm.joinRoom(code: code, username: username) } })
            }
            if let message = vm.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding(48)
        .onChange(of: vm.roomID) { oldValue, newValue in
            guard let id = newValue else { return }
            navVM.goToRoomLobby(id: id, name: vm.room?.name)
        }
    }
}

struct CreateRoomView: View {
    @Binding var username: String
    @Binding var roomName: String
    var isLoading: Bool = false
    var onStart: () -> Void = {}
    var body: some View {
        Image(systemName: "photo")
            .resizable()
            .scaledToFit()
            .frame(width: 128, height: 128)
            .foregroundColor(Color.gray)
        TextField("Enter your name", text: $username)
        TextField("Enter room name", text: $roomName)
        Button(action: onStart) {
            Text(isLoading ? "Creating..." : "Start")
                .frame(maxWidth: .infinity)
        }
        .primaryButton(color: isLoading ? Color.gray : Color.blue)
        .disabled(isLoading)
    }
}

struct JoinRoomView: View {
    @Binding var username: String
    @Binding var code: String
    var isLoading: Bool = false
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
            Text(isLoading ? "Joining..." : "Join")
                .frame(maxWidth: .infinity)
        }
        .primaryButton(color: isLoading ? Color.gray : Color.blue)
        .disabled(isLoading)
    }
}

#Preview {
    EntryRoomView()
}
