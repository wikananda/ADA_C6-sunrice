//
//  UserService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import Foundation
import Supabase
import PostgREST

struct UserService: UserServicing {
    let client: SupabaseClient
    
    func createUser(username: String = "user") async throws -> UserDTO {
        let params = ["_username": username]
        let response: PostgrestResponse<UserDTO> = try await client
            .rpc("create_guest_user", params: params)
            .execute()
        return response.value
    }
}
