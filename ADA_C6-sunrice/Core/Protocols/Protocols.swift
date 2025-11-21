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

protocol RoomServicing {
    func createRoom(name: String, hostId: Int64) async throws -> SessionDTO
    func joinRoom(code: String, userId: Int64) async throws -> SessionDTO
}
