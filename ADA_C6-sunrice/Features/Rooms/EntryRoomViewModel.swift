//
//  EntryRoomViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import SwiftUI
import Combine

@MainActor
final class EntryRoomViewModel: ObservableObject {
    private let userService: UserService = UserService(client: supabaseManager)
    private let roomService: RoomService = RoomService(client: supabaseManager)
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var roomID: String?
    @Published private(set) var user: UserDTO?
    @Published private(set) var room: RoomDTO?
    
    func createRoom(username: String, roomName: String) async {
        guard !username.isEmpty, !roomName.isEmpty else {
            errorMessage = "Username or room name are empty"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _user = try await userService.createUser(username: username)
            let _room = try await roomService.createRoom(name: roomName, hostId: _user.id)
            
            user = _user
            room = _room
            roomID = _room.id.uuidString
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func joinRoom(code: String, username: String) async {
        guard !code.isEmpty, !username.isEmpty else {
            errorMessage = "Username or room code are empty"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _user = try await userService.createUser(username: username)
            let _room = try await roomService.joinRoom(code: code, userId: _user.id)
            
            user = _user
            room = _room
            roomID = _room.id.uuidString
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
