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
    
    func fetchSummary(sessionId: Int, roundType: RoundType, isHost: Bool) async {
        guard shouldFetchSummary(for: roundType) else {
            print("⏭️ Skipping summary for round type: \(roundType)")
            return
        }
        
        isLoadingSummary = true
        summaryError = nil
        defer { isLoadingSummary = false }
        
        do {
            let ideaType = getIdeaType(for: roundType)
            
            // Guests: Poll for existing summary from database
            if !isHost {
                print("📊 Guest: Polling for summary from database...")
                
                // Poll every 2 seconds until summary is found
                // Poll until summary is found or task is cancelled
                while !Task.isCancelled {
                    do {
                        if let existingSummary = try await summaryService.fetchExistingSummary(sessionId: sessionId, roundType: ideaType) {
                            summary = existingSummary
                            print("✅ Guest: Retrieved summary with \(existingSummary.themes.count) themes")
                            return
                        }
                    } catch {
                        print("⚠️ Guest: Error polling for summary: \(error)")
                    }
                    
                    print("⏳ Guest: Summary not ready yet, retrying in 2 seconds...")
                    
                    do {
                        try await Task.sleep(nanoseconds: 2_000_000_000)
                    } catch {
                        print("🛑 Guest: Polling cancelled")
                        return
                    }
                }
                return
            }
            
            // Host: Generate new summary
            print("📊 Host: Generating summary for session \(sessionId)...")
            
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
                print("✅ Host: Summary generated successfully with \(response.summary.themes.count) themes")
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
    
    private func getIdeaType(for roundType: RoundType) -> Int {
        // Map RoundType to idea_type in database
        switch roundType {
        case .white: return 1
        case .green: return 2
        case .red: return 6
        default: return 0
        }
    }
}
