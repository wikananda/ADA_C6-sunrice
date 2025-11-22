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
}

protocol SessionServicing {
    func createSession(topic: String,
        description: String,
        duration_per_round: String,
        mode_id: Int64
    ) async throws -> SessionDTO
    func joinSession(code: String, userId: Int64) async throws -> SessionDTO
}
