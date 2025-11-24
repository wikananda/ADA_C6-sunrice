//
//  IdeaService.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import Foundation
import Supabase

struct IdeaService: IdeaServicing {
    let client: SupabaseClient
    
    // Fetch ideas for a session, optionally filtered by type
    func fetchIdeas(sessionId: Int64, typeId: Int64?) async throws -> [IdeaDTO] {
        var query = client
            .from("ideas")
            .select()
            .eq("session_id", value: Int(sessionId))
        
        if let typeId = typeId {
            query = query.eq("type_id", value: Int(typeId))
        }
        
        let response: PostgrestResponse<[IdeaDTO]> = try await query
            .order("created_at", ascending: true)
            .execute()
        
        return response.value
    }
    
    // Batch create ideas
    func createIdeas(_ params: [InsertIdeaParams]) async throws {
        guard !params.isEmpty else { return }
        
        try await client
            .from("ideas")
            .insert(params)
            .execute()
    }
    
    // Create a single comment
    func createComment(_ params: InsertCommentParams) async throws {
        try await client
            .from("ideas_comments")
            .insert(params)
            .execute()
    }
    
    // Fetch all comments for multiple ideas
    func fetchCommentsForIdeas(ideaIds: [Int64]) async throws -> [IdeaCommentDTO] {
        guard !ideaIds.isEmpty else { return [] }
        
        let response: PostgrestResponse<[IdeaCommentDTO]> = try await client
            .from("ideas_comments")
            .select()
            .in("idea_id", values: ideaIds.map { Int($0) })
            .order("created_at", ascending: true)
            .execute()
        
        print("fetched comments: \(response.value)")
        return response.value
    }
}
