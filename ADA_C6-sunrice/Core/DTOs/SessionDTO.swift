//
//  SessionDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//

import SwiftData
import Foundation

struct SessionDTO: Decodable {
    let id: Int64
    let duration_per_round: String?
    let topic: String?
    let token: String?
    let is_token_expired: Bool?
    let started_at: Date?
    let ended_at: Date?
    let created_at: Date?
}
