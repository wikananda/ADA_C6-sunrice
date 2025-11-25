//
//  SummaryManager.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 25/11/25.
//

import Foundation
import Combine

@MainActor
final class SummaryManager: ObservableObject {
    private let summaryService: SummaryServicing
    
    @Published var summary: IdeaSummary?
    @Published var isLoadingSummary: Bool = false
    @Published var summaryError: String?
    
    init(summaryService: SummaryServicing) {
        self.summaryService = summaryService
    }
    
    // MARK: - Summary Operations
    
    func fetchSummary(sessionId: Int, roundType: RoundType) async {
        guard shouldFetchSummary(for: roundType) else {
            print("⏭️ Skipping summary for round type: \(roundType)")
            return
        }
        
        isLoadingSummary = true
        summaryError = nil
        defer { isLoadingSummary = false }
        
        do {
            print("📊 Fetching \(roundType) summary for session \(sessionId)...")
            
            let response: SummarizeSessionResponse<IdeaSummary>
            
            switch roundType {
            case .white:
                response = try await summaryService.summarizeWhiteSession(sessionId: sessionId)
            case .green:
                response = try await summaryService.summarizeGreenSession(sessionId: sessionId)
            case .red:
                response = try await summaryService.summarizeRedSession(sessionId: sessionId)
            default:
                print("⏭️ No summary available for \(roundType)")
                return
            }
            
            if response.success {
                summary = response.summary
                print("✅ Summary fetched successfully with \(response.summary.themes.count) themes")
            } else {
                summaryError = "Summary generation failed"
                print("❌ Summary generation failed")
            }
        } catch {
            summaryError = error.localizedDescription
            print("❌ Error fetching summary: \(error)")
        }
    }
    
    func clearSummary() {
        summary = nil
        summaryError = nil
    }
    
    // MARK: - Helper Methods
    
    private func shouldFetchSummary(for roundType: RoundType) -> Bool {
        // Only fetch summary for white, green, and red rounds
        switch roundType {
        case .white, .green, .red:
            return true
        default:
            return false
        }
    }
}
