//
//  UserRoleService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 22/11/25.
//

import Foundation
import PostgREST
import Supabase

struct UserRoleService: UserRoleServicing {
    let client: SupabaseClient
    
    func createUserRole(roleId: Int64) async throws -> UserRoleDTO {
        let payload = CreateUserRolePayload(role_id: roleId)
        let response: PostgrestResponse<UserRoleDTO> = try await client
            .from("user_roles")
            .insert(payload, returning: .representation)
            .single()
            .execute()
        return response.value
    }
    
    func attach(userId: Int64, toRole roleId: Int64) async throws -> UserRoleDTO {
        let payload = UpdateUserRolePayload(user_id: userId)
        let response: PostgrestResponse<UserRoleDTO> = try await client
            .from("user_roles")
            .update(payload, returning: .representation)
            .eq("id", value: Int(roleId))
            .single()
            .execute()
        return response.value
    }
}

// Payloads
private struct CreateUserRolePayload: Encodable {
    let role_id: Int64
}

private struct UpdateUserRolePayload: Encodable {
    let user_id: Int64
}
