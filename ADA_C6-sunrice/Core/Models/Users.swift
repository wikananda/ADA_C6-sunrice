//
//  Users.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 09/11/25.
//
import Supabase
import Foundation

struct Users: Decodable, Identifiable {
    let id: UUID
    let username: String
    let status: String
    let created_at: String?
}
