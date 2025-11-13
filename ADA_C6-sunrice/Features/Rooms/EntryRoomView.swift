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
    
    @State var mode: EntryMode = .join
    
    var body: some View {
        VStack(spacing: 28) {
            switch mode {
                case .create:
                    CreateRoomView(
                        username: $vm.username,
                        roomName: $vm.roomName,
                        isLoading: vm.isLoading,
                        isEnabled: vm.canCreate,
                        onStart: { Task { await vm.createRoom() } }
                    )
                case .join:
                JoinRoomView(
                    username: $vm.username,
                    code: $vm.code,
                    isLoading: vm.isLoading,
                    isEnabled: vm.canJoin,
                    onJoin: { Task { await vm.joinRoom() } })
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
        .onChange(of: vm.username) { _, _ in vm.errorMessage = nil }
        .onChange(of: vm.roomName) { _, _ in vm.errorMessage = nil }
        .onChange(of: vm.code) { _, _ in vm.errorMessage = nil }
    }
}

struct CreateRoomView: View {
    @Binding var username: String
    @Binding var roomName: String
    var isLoading: Bool = false
    var isEnabled: Bool = true
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
        .primaryButton(color: (isLoading || !isEnabled) ? Color.gray : Color.blue)
        .disabled(isLoading || !isEnabled)
    }
}

struct JoinRoomView: View {
    @Binding var username: String
    @Binding var code: String
    var isLoading: Bool = false
    var isEnabled: Bool = true
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
        .primaryButton(color: (isLoading || !isEnabled) ? Color.gray : Color.blue)
        .disabled(isLoading || !isEnabled)
    }
}

#Preview {
    EntryRoomView()
}
