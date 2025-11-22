//
//  SessionDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//

import Foundation

struct SessionDTO: Decodable, Sendable {
    let id: Int64
    let duration_per_round: String?
    let topic: String?
    let description: String?
    let token: String?
    let is_token_expired: Bool?
    let started_at: Date?
    let ended_at: Date?
    let created_at: Date?
    let mode_id: Int64?
}
