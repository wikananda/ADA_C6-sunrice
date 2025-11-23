//
//  Protocols.swift
//  ADA_C6-sunrice
//
//  Created by Codex on 11/13/25.
//
import Foundation

protocol UserServicing {
    func createUser(name: String) async throws -> UserDTO
}

protocol UserRoleServicing {
    func createUserRole(roleId: Int64) async throws -> UserRoleDTO
    func attach(userId: Int64, toRole roleId: Int64) async throws -> UserRoleDTO
    func createUserRoleSession(userId: Int64, roleId: Int64, sessionId: Int64) async throws -> UserRoleSessionDTO
    func fetchParticipants(sessionId: Int64) async throws -> [ParticipantDTO]
}

protocol UserRoleSessionServicing {
    func createUserRoleSession(userId: Int64, roleId: Int64, sessionId: Int64) async throws -> UserRoleSessionDTO
}

protocol SessionServicing {
    func createSession(topic: String,
        description: String,
        duration_per_round: Int64,
        mode_id: Int64
    ) async throws -> SessionDTO
    func fetchSession(id: Int64) async throws -> SessionDTO
    func fetchSession(token: String) async throws -> SessionDTO
    func fetchMode(id: Int64) async throws -> ModeDTO
    func fetchModes() async throws -> [ModeDTO]
    func startSession(id: Int64) async throws -> TypeDTO
}
