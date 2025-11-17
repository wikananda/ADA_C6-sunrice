//
//  EntrySessionViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import SwiftUI
import Combine

@MainActor
final class EntrySessionViewModel: ObservableObject {
    private let userService: UserService = UserService(client: supabaseManager)
    private let sessionService: SessionService = SessionService(client: supabaseManager)
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // navigation pakai String
    @Published var sessionID: String?
    
    @Published private(set) var user: UserDTO?
    @Published private(set) var session: SessionDTO?
    
    func createSession(username: String, sessionName: String) async {
        guard !username.isEmpty, !sessionName.isEmpty else {
            errorMessage = "Username or session name are empty"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _user = try await userService.createUser(username: username)
            let _session = try await sessionService.createSession(name: sessionName, hostId: _user.id)
            
            user = _user
            session = _session
            sessionID = String(_session.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func joinSession(code: String, username: String) async {
        guard !code.isEmpty, !username.isEmpty else {
            errorMessage = "Username or session code are empty"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _user = try await userService.createUser(username: username)
            let _session = try await sessionService.joinSession(code: code, userId: _user.id)
            
            user = _user
            session = _session
            sessionID = String(_session.id)
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
