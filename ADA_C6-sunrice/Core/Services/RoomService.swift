//
//  RoomService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 05/11/25.
//
import Foundation
import Supabase
import PostgREST

struct RoomService: RoomServicing {
    let dbClient: SupabaseClient
    
    func createRoom(name: String = "Your room", hostId: UUID) async throws -> RoomDTO {
        let params: [String: String] = [
            "_name": name,
            "_hostid": hostId.uuidString
        ]
        
        let response: PostgrestResponse<RoomDTO> = try await dbClient
            .rpc("create_room", params: params)
            .execute()
        return response.value
    }
    
    func joinRoom(code: String, userId: UUID) async throws -> RoomDTO {
        let params: [String: String] = [
            "p_code": code,
            "_userid": userId.uuidString
        ]
        
        let response: PostgrestResponse<RoomDTO> = try await dbClient
            .rpc("join_room_by_code", params: params)
            .execute()
        return response.value
    }
}
