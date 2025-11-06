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
    private let userService: UserService = UserService(client: dbClient)
    private let roomService: RoomService = RoomService(client: dbClient)
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var createdRoomID: String?
    @Published private(set) var createdUser: UserDTO?
    @Published private(set) var createdRoom: RoomDTO?
    
    func createRoom(username: String, roomName: String) async {
        guard !username.isEmpty, !roomName.isEmpty else {
            errorMessage = "Username or room name are empty"
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        do {
            let user = try await userService.createUser(username: username)
            let room = try await roomService.createRoom(name: roomName, hostId: user.id)
            
            createdUser = user
            createdRoom = room
            createdRoomID = room.id.uuidString
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
