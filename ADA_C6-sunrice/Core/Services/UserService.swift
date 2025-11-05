//
//  UserService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import SwiftData
import Foundation

struct UserDTO: Codable, Sendable {
    var id: UUID
    var username: String?
    var created_at: Date
    var status: String
}
