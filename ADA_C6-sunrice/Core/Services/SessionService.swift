//
//  SessionService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import PostgREST
import Foundation
import Supabase

struct SessionService: SessionServicing {
    let client: SupabaseClient
    
    func createSession(
        topic: String,
        description: String,
        duration_per_round: String,
        mode_id: Int64
    ) async throws -> SessionDTO {
        let payload = NewSessionPayload(
            duration_per_round: duration_per_round,
            topic: topic,
            description: description,
            mode_id: mode_id
        )
        
        let response: PostgrestResponse<SessionDTO> = try await client
            .from("sessions")
            .insert(payload, returning: .representation)
            .single()
            .execute()
        return response.value
    }
    
    func retrieveMode(mode_id id: Int) async throws -> ModeDTO {
        let response: PostgrestResponse<ModeDTO> = try await client
            .from("modes")
            .select()
            .eq("id", value: id)
            .single()
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

private struct NewSessionPayload: Encodable {
    let duration_per_round: String
    let topic: String
    let description: String?
    let mode_id: Int64
    let is_token_expired: Bool = false
}
