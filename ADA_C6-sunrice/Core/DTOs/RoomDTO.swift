//
//  RoomDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import SwiftData
import Foundation

struct RoomDTO: Decodable {
    let id: UUID
    let name: String?
    let state: String
    let host_id: UUID
    let created_at: Date
    let updated_at: Date
    let code: String
}
