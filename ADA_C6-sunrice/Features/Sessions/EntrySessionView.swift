//
//  CreateSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftUI

enum EntryMode { case create, join }

struct EntrySessionView: View {
    @EnvironmentObject var navVM: NavigationViewModel
    @StateObject private var vm = EntrySessionViewModel()
    
    @State var mode: EntryMode = .create
    @State private var username: String = ""
    @State private var sessionName: String = ""
    @State private var code: String = ""
    
    var body: some View {
        VStack(spacing: 28) {
            switch mode {
                case .create:
                    CreateSessionView(
                        username: $username,
                        sessionName: $sessionName,
                        isLoading: vm.isLoading,
                        onStart: { Task { await vm.createSession(username: username, sessionName: sessionName) } }
                    )
                case .join:
                JoinSessionOldView(
                    username: $username,
                    code: $code,
                    isLoading: vm.isLoading,
                    onJoin: { Task { await vm.joinSession(code: code, username: username) } })
            }
            if let message = vm.errorMessage {
                Text(message)
                    .font(.footnote)
                    .foregroundStyle(.red)
            }
        }
        .padding(48)
//        .onChange(of: vm.sessionID) { oldValue, newValue in
//            guard let id = newValue else { return }
//            print("DEBUG %f", id)
            // ini kenapa bawa id ya? id apa?
            // navVM.goToSessionLobby(id: id)
//        }
//        .onChange(of: vm.username) { _, _ in vm.errorMessage = nil }
//        .onChange(of: vm.roomName) { _, _ in vm.errorMessage = nil }
//        .onChange(of: vm.code) { _, _ in vm.errorMessage = nil }
    }
}

struct CreateSessionView: View {
    @Binding var username: String
    @Binding var sessionName: String
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
        TextField("Enter session name", text: $sessionName)
        Button(action: onStart) {
            Text(isLoading ? "Creating..." : "Start")
                .frame(maxWidth: .infinity)
        }
        .primaryButton(color: (isLoading || !isEnabled) ? Color.gray : Color.blue)
        .disabled(isLoading || !isEnabled)
    }
}

struct JoinSessionOldView: View {
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
    EntrySessionView()
}
