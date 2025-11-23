//
//  UserRoleSessionDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 24/11/25.
//

import Foundation

struct UserRoleSessionDTO: Decodable, Sendable {
    let id: Int64
    let user_id: Int64?
    let role_id: Int64?
    let session_id: Int64?
    let created_at: Date?
}
