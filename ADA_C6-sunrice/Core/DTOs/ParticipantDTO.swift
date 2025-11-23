//
//  ParticipantDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 24/11/25.
//

import Foundation

struct ParticipantDTO: Decodable, Sendable, Identifiable {
    let id: Int64
    let name: String?
    let status: Int64?
    let created_at: Date?
    let user_role_sessions: [UserRoleSessionInfo]
    
    var roleId: Int64? {
        user_role_sessions.first?.role_id
    }
    
    var isHost: Bool {
        roleId == 1
    }
    
    struct UserRoleSessionInfo: Decodable, Sendable {
        let role_id: Int64
    }
}
