//
//  Protocols.swift
//  ADA_C6-sunrice
//
//  Created by Codex on 11/13/25.
//
import Foundation

protocol UserServicing {
    func createUser(username: String) async throws -> UserDTO
}

protocol RoomServicing {
    func createRoom(name: String, hostId: UUID) async throws -> RoomDTO
    func joinRoom(code: String, userId: UUID) async throws -> RoomDTO
}

