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
    private let userService: UserServicing
    private let roomService: RoomServicing
    
    // Inputs
    @Published var username: String = ""
    @Published var roomName: String = ""
    @Published var code: String = ""
    
    // Outputs / state
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var roomID: String?
    @Published private(set) var user: UserDTO?
    @Published private(set) var room: RoomDTO?
    
    // Derived UI state
    // Can create or join if username, roomname/code is filled (and currently not loading)
    var canCreate: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !roomName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isLoading
    }
    var canJoin: Bool {
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !code.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        && !isLoading }
    
    init(userService: UserServicing = UserService(dbClient: dbClient), roomService: RoomServicing = RoomService(dbClient: dbClient)) {
        self.userService = userService
        self.roomService = roomService
    }
    
    func createRoom() async {
        let name = roomName.trimmingCharacters(in: .whitespacesAndNewlines)
        let uname = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !uname.isEmpty, !name.isEmpty else {
            errorMessage = "Username or room name are empty"
            return
        }
        
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _user = try await userService.createUser(username: uname)
            let _room = try await roomService.createRoom(name: name, hostId: _user.id)
            
            user = _user
            room = _room
            roomID = _room.id.uuidString
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // create room wrapper
    func createRoom(username: String, roomName: String) async {
        self.username = username
        self.roomName = roomName
        await createRoom()
    }
    
    func joinRoom() async {
        let _code = code.trimmingCharacters(in: .whitespacesAndNewlines)
        let uname = username.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !_code.isEmpty, !uname.isEmpty else {
            errorMessage = "Username or room code are empty"
            return
        }
        
        errorMessage = nil
        isLoading = true
        defer { isLoading = false }
        
        do {
            let _user = try await userService.createUser(username: uname)
            let _room = try await roomService.joinRoom(code: _code, userId: _user.id)
            
            user = _user
            room = _room
            roomID = _room.id.uuidString
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Backward-compatible wrapper (optional use)
    func joinRoom(code: String, username: String) async {
        self.code = code
        self.username = username
        await joinRoom()
    }
}
