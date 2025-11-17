//
//  SessionService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import PostgREST
import Foundation
import Supabase

struct SessionService {
    let client: SupabaseClient
    
    func createSession(name: String = "Your session", hostId: Int64) async throws -> SessionDTO {
        let params: [String: String] = [
            "_name": name,
            "_hostid": String(hostId)
        ]
        
        let response: PostgrestResponse<SessionDTO> = try await client
            .rpc("create_session", params: params)
            .execute()
        
        return response.value
    }
    
    func joinSession(code: String, userId: Int64) async throws -> SessionDTO {
        let params: [String: String] = [
            "p_code": code,
            "_userid": String(userId)
        ]
        
        let response: PostgrestResponse<SessionDTO> = try await client
            .rpc("join_session_by_code", params: params)
            .execute()
        
        return response.value
    }
}
