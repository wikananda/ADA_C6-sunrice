//
//  UserService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import Foundation
import Supabase
import PostgREST

//struct UserService: UserServicing {
//    let client: SupabaseClient
//    
//    func createUser(username: String = "user") async throws -> UserDTO {
//        let params = ["_username": username]
//        let response: PostgrestResponse<UserDTO> = try await client
//            .rpc("create_guest_user", params: params)
//            .execute()
//        return response.value
//    }
//}

struct UserService: UserServicing {
    let client: SupabaseClient
    
    func createUser(name: String = "user") async throws -> UserDTO {
        let payload = CreateUserPayload(name: name)
        let response: PostgrestResponse<UserDTO> = try await client
            .from("users")
            .insert(payload, returning: .representation)
            .single()
            .execute()
        return response.value
    }
}

private struct CreateUserPayload: Encodable {
    let name: String
}
