//
//  SupabaseUserModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import SwiftData
import Foundation

struct UserDTO: Decodable, Sendable {
    let id: UUID
    let username: String
    let created_at: Date
    let status: String
}
