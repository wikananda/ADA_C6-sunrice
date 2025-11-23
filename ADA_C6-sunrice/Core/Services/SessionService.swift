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
        let token = try await generateSessionToken()
        let payload = NewSessionPayload(
            duration_per_round: duration_per_round,
            topic: topic,
            description: description,
            mode_id: mode_id,
            token: token
        )
        
        let response: PostgrestResponse<SessionDTO> = try await client
            .from("sessions")
            .insert(payload, returning: .representation)
            .single()
            .execute()
        return response.value
    }
    
    func generateSessionToken() async throws -> String {
        let response: PostgrestResponse<String> = try await client
            .rpc("generate_unique_token", params: [String: String]())
            .execute()
        return response.value
    }
    
    func fetchSession(id: Int64) async throws -> SessionDTO {
        let response: PostgrestResponse<SessionDTO> = try await client
            .from("sessions")
            .select()
            .eq("id", value: Int(id))
            .single()
            .execute()
        
        return response.value
    }
    
    func fetchSession(token: String) async throws -> SessionDTO {
        let response: PostgrestResponse<SessionDTO> = try await client
            .from("sessions")
            .select()
            .eq("token", value: token)
            .single()
            .execute()
        
        return response.value
    }
    
    func fetchMode(id: Int64) async throws -> ModeDTO {
        let response: PostgrestResponse<ModeDTO> = try await client
            .from("modes")
            .select()
            .eq("id", value: Int(id))
            .single()
            .execute()
        
        return response.value
    }
    
    func fetchModes() async throws -> [ModeDTO] {
        let response: PostgrestResponse<[ModeDTO]> = try await client
            .from("modes")
            .select()
            .execute()
        return response.value
    }
}

private struct NewSessionPayload: Encodable {
    let duration_per_round: String
    let topic: String
    let description: String?
    let mode_id: Int64
    let token: String
    let is_token_expired: Bool = false
}
