//
//  UserRoleDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 22/11/25.
//

import Foundation

struct UserRoleDTO: Decodable, Sendable {
    let id: Int64
    let role_id: Int64
    let user_id: Int64?
    let created_at: Date?
}
