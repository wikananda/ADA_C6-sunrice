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
    let dbClient: SupabaseClient
    
    func createUser(username: String = "user") async throws -> UserDTO {
        let params = ["_username": username]
        let response: PostgrestResponse<UserDTO> = try await dbClient
            .rpc("create_guest_user", params: params)
            .execute()
        return response.value
    }
}
