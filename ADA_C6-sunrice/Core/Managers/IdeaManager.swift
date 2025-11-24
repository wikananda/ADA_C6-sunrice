//
//  IdeaManager.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import Foundation
import Combine
import Supabase

@MainActor
final class IdeaManager: ObservableObject {
    private let ideaService: IdeaServicing
    
    // Local storage (before upload)
    @Published var localIdeas: [LocalIdea] = []
    @Published var localComments: [LocalComment] = []
    
    // Server data (after fetch)
    @Published var serverIdeas: [IdeaDTO] = []
    @Published var serverComments: [IdeaCommentDTO] = []  // Comments for review screen
    @Published var commentCounts: [Int64: CommentCounts] = [:]
    
    @Published var isUploadingIdeas: Bool = false
    
    init(ideaService: IdeaServicing) {
        self.ideaService = ideaService
    }
    
    // MARK: - Local Idea Management
    
    func addLocalIdea(text: String, typeId: Int64) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let localIdea = LocalIdea(text: trimmedText, typeId: typeId)
        localIdeas.append(localIdea)
    }
    
    func clearLocalIdeas() {
        localIdeas.removeAll()
    }
    
    // MARK: - Local Comment Management
    
    func addLocalComment(ideaId: Int64, text: String, typeId: Int64) {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else { return }
        
        let localComment = LocalComment(ideaId: ideaId, text: trimmedText, typeId: typeId)
        localComments.append(localComment)
    }
    
    // MARK: - Upload Operations
    
    func uploadLocalIdeas(sessionId: Int64, userId: Int64) async throws {
        guard !localIdeas.isEmpty else {
            print("⏭️ No local ideas to upload")
            return
        }
        
        isUploadingIdeas = true
        defer { isUploadingIdeas = false }
        
        // Convert local ideas to insert params
        let params = localIdeas.map { idea in
            InsertIdeaParams(
                text: idea.text,
                type_id: idea.typeId,
                session_id: sessionId,
                user_id: userId
            )
        }
        
        print("📤 Uploading \(params.count) ideas to database...")
        
        // Upload to database
        try await ideaService.createIdeas(params)
        
        // Clear local ideas after successful upload
        localIdeas.removeAll()
        
        print("✅ Successfully uploaded \(params.count) ideas")
    }
    
    func submitComment(ideaId: Int64, text: String, typeId: Int64, userId: Int64) async throws {
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty else {
            throw IdeaManagerError.emptyComment
        }
        
        print("💬 Submitting comment for idea \(ideaId) to ideas_comments table...")
        
        let params = InsertCommentParams(
            idea_id: ideaId,
            text: trimmedText,
            type_id: typeId,
            user_id: userId
        )
        
        try await ideaService.createComment(params)
        
        print("✅ Comment submitted successfully to ideas_comments table")
    }
    
    // MARK: - Fetch Operations
    
    func fetchIdeas(sessionId: Int64, typeId: Int64?) async throws {
        serverIdeas = try await ideaService.fetchIdeas(sessionId: sessionId, typeId: typeId)
        
        print("✅ Fetched \(serverIdeas.count) ideas for session \(sessionId), typeId: \(typeId ?? -1)")
        for idea in serverIdeas {
            print("  - Idea \(idea.id): '\(idea.text ?? "")' by user \(idea.user_id ?? -1)")
        }
    }
    
    func fetchCommentCounts(roundManager: RoundManager) async throws {
        let ideaIds = serverIdeas.map { $0.id }
        guard !ideaIds.isEmpty else { return }
        
        print("📊 Fetching comment counts for \(ideaIds.count) ideas using RPC...")
        
        // Use the RPC function to get aggregated counts
        struct CommentCountResult: Decodable {
            let idea_id: Int64
            let yellow_count: Int
            let black_count: Int
            let dark_green_count: Int
        }
        
        do {
            let response: [CommentCountResult] = try await supabaseManager
                .rpc(
                    "get_comment_counts_for_ideas",
                    params: ["idea_ids": ideaIds]
                )
                .execute().value
            
            print("   - Retrieved counts for \(response.count) ideas from RPC")
            
            // Convert to dictionary
            var counts: [Int64: CommentCounts] = [:]
            for result in response {
                counts[result.idea_id] = CommentCounts(
                    yellow: result.yellow_count,
                    black: result.black_count,
                    darkGreen: result.dark_green_count
                )
            }
            
            commentCounts = counts
            print("✅ Updated comment counts for \(counts.count) ideas")
        } catch {
            print("⚠️ RPC failed, falling back to manual aggregation: \(error)")
            // Fallback to manual aggregation
            try await fetchCommentCountsManually(roundManager: roundManager)
        }
    }
    
    // Fallback method if RPC fails
    private func fetchCommentCountsManually(roundManager: RoundManager) async throws {
        let ideaIds = serverIdeas.map { $0.id }
        guard !ideaIds.isEmpty else { return }
        
        let comments = try await ideaService.fetchCommentsForIdeas(ideaIds: ideaIds)
        print("   - Retrieved \(comments.count) total comments from DB (manual)")
        
        // Count comments by type for each idea
        var counts: [Int64: CommentCounts] = [:]
        
        for comment in comments {
            guard let ideaId = comment.idea_id, let typeId = comment.type_id else { continue }
            
            var current = counts[ideaId] ?? CommentCounts(yellow: 0, black: 0, darkGreen: 0)
            
            if roundManager.isYellowType(typeId) {
                current.yellow += 1
            } else if roundManager.isBlackType(typeId) {
                current.black += 1
            } else if roundManager.isDarkGreenType(typeId) {
                current.darkGreen += 1
            }
            
            counts[ideaId] = current
        }
        
        commentCounts = counts
        print("✅ Updated comment counts for \(counts.count) ideas (manual)")
    }
    
    // Fetch all comments for display in review screen
    func fetchComments(roundManager: RoundManager) async throws {
        let ideaIds = serverIdeas.map { $0.id }
        guard !ideaIds.isEmpty else { 
            serverComments = []
            return 
        }
        
        print("💬 Fetching all comments for \(ideaIds.count) ideas...")
        
        serverComments = try await ideaService.fetchCommentsForIdeas(ideaIds: ideaIds)
        print("✅ Fetched \(serverComments.count) comments for review screen")
    }
    
    // MARK: - Reset
    
    func reset() {
        localIdeas.removeAll()
        localComments.removeAll()
        serverIdeas.removeAll()
        serverComments.removeAll()
        commentCounts.removeAll()
    }
}

// MARK: - Errors

enum IdeaManagerError: LocalizedError {
    case emptyComment
    
    var errorDescription: String? {
        switch self {
        case .emptyComment:
            return "Comment text cannot be empty"
        }
    }
}
