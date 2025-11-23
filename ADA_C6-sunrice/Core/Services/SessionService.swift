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
        duration_per_round: Int64,
        mode_id: Int64
    ) async throws -> SessionDTO {
        let params = CreateSessionParams(
            _duration_per_round: Int64(duration_per_round),
            _topic: topic,
            _description: description,
            _mode_id: mode_id
        )
        print("HEREEE FIRST")
        let response: PostgrestResponse<RPCSessionResponseDTO> = try await client
            .rpc("create_session_with_token", params: params)
            .single()
            .execute()
        print("HEREEE")
        let rpcSession = response.value
        print("HERE AFTER")
        return SessionDTO(
            id: rpcSession.session_id,
            duration_per_round: duration_per_round,
            topic: rpcSession.topic,
            description: rpcSession.description,
            token: rpcSession.token,
            is_token_expired: false,
            started_at: nil,
            ended_at: nil,
            created_at: Date(),
            mode_id: rpcSession.mode_id
        )
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
    
    func startSession(id: Int64) async throws {
        let payload = StartSessionPayload(is_token_expired: true, started_at: Date())
        try await client
            .from("sessions")
            .update(payload)
            .eq("id", value: Int(id))
            .execute()
    }
}

private struct StartSessionPayload: Encodable, Sendable {
    let is_token_expired: Bool
    let started_at: Date
}

private struct NewSessionPayload: Encodable, Sendable {
    let duration_per_round: String
    let topic: String
    let description: String?
    let mode_id: Int64
    let token: String
    let is_token_expired: Bool = false
}
