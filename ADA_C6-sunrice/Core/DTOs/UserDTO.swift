//
//  SupabaseUserModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import Foundation

struct UserDTO: Decodable, Sendable {
    let id: Int64
    let name: String?
    let status: Int64?
    let created_at: Date?
}

