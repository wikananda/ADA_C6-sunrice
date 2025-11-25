//
//  SummaryService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 25/11/25.
//

import Supabase
import Foundation

struct SummaryService: SummaryServicing {
    let client: SupabaseClient
    
    // Summarize session
    func summarizeWhiteSession(sessionId: Int) async throws -> SummarizeSessionResponse<IdeaSummary> {
        let body: [String: Int] = [
            "session_id": sessionId,
            "idea_type": 1
        ]

        let response: SummarizeSessionResponse<IdeaSummary> = try await client
            .functions
            .invoke(
                "summarize-session",
                options: FunctionInvokeOptions(
                    body: body
                )
            )

        return response
    }
    
    func summarizeGreenSession(sessionId: Int) async throws -> SummarizeSessionResponse<IdeaSummary> {
        let body: [String: Int] = [
            "session_id": sessionId,
            "idea_type": 2
        ]

        let response: SummarizeSessionResponse<IdeaSummary> = try await client
            .functions
            .invoke(
                "summarize-session",
                options: FunctionInvokeOptions(
                    body: body
                )
            )

        return response
    }
    
    func summarizeRedSession(sessionId: Int) async throws -> SummarizeSessionResponse<IdeaSummary> {
        let body: [String: Int] = [
            "session_id": sessionId,
            "idea_type": 6
        ]

        let response: SummarizeSessionResponse<IdeaSummary> = try await client
            .functions
            .invoke(
                "summarize-session",
                options: FunctionInvokeOptions(
                    body: body
                )
            )

        return response
    }
}
