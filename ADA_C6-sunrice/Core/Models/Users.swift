//
//  Users.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 09/11/25.
//
import Supabase
import Foundation

struct User: Decodable, Identifiable {
    let id: Int64
    let name: String
    let status: Int64
    let created_at: Date?
    let is_active: Bool?
}

//struct User: Decodable, Identifiable {
//    let id: UUID
//    let username: String
//    let status: String
//    let created_at: String?
//}
