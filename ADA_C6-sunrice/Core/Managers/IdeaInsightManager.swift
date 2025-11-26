//
//  IdeaInsightManager.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 26/11/25.
//

import Foundation
import Combine

@MainActor
final class IdeaInsightManager: ObservableObject {
    private let insightService: IdeaInsightServicing
    
    @Published var insights: [IdeaInsightDTO] = []
    @Published var isAnalyzing: Bool = false
    @Published var analysisProgress: String = ""
    @Published var analysisError: String?
    
    init(insightService: IdeaInsightServicing) {
        self.insightService = insightService
    }
    
    // MARK: - Analysis Operations
    
    func analyzeAllIdeas(sessionId: Int, greenIdeaIds: [Int], isHost: Bool) async {
        isAnalyzing = true
        analysisError = nil
        defer { isAnalyzing = false }
        
        if isHost {
            // Host: Call analyze-idea for each green idea
            await analyzeIdeasAsHost(sessionId: sessionId, greenIdeaIds: greenIdeaIds)
        } else {
            // Guest: Poll for existing insights
            await fetchInsightsAsGuest(sessionId: sessionId, expectedCount: greenIdeaIds.count)
        }
    }
    
    // MARK: - Host Logic
    
    private func analyzeIdeasAsHost(sessionId: Int, greenIdeaIds: [Int]) async {
        let total = greenIdeaIds.count
        
        for (index, ideaId) in greenIdeaIds.enumerated() {
            if Task.isCancelled {
                print("🛑 Analysis cancelled")
                return
            }
            
            analysisProgress = "Analyzing idea \(index + 1) of \(total)..."
            
            do {
                let response = try await insightService.analyzeIdea(
                    sessionId: sessionId,
                    greenIdeaId: ideaId
                )
                
                if response.success {
                    insights.append(response.insight)
                    print("✅ Analyzed idea \(ideaId)")
                }
            } catch {
                print("❌ Error analyzing idea \(ideaId): \(error)")
                analysisError = "Failed to analyze some ideas"
            }
        }
        
        analysisProgress = "Analysis complete!"
        print("✅ All ideas analyzed: \(insights.count) insights")
    }
    
    // MARK: - Guest Logic
    
    private func fetchInsightsAsGuest(sessionId: Int, expectedCount: Int) async {
        analysisProgress = "Waiting for host to complete analysis..."
        
        // Poll every 2 seconds until all insights are ready
        while !Task.isCancelled {
            do {
                let fetchedInsights = try await insightService.fetchIdeaInsights(sessionId: sessionId)
                
                if fetchedInsights.count >= expectedCount {
                    insights = fetchedInsights
                    analysisProgress = "Analysis complete!"
                    print("✅ Guest: Retrieved \(insights.count) insights")
                    return
                }
                
                analysisProgress = "Waiting for analysis (\(fetchedInsights.count)/\(expectedCount))..."
                print("⏳ Guest: \(fetchedInsights.count)/\(expectedCount) insights ready, retrying in 2 seconds...")
                
            } catch {
                print("⚠️ Guest: Error fetching insights: \(error)")
            }
            
            do {
                try await Task.sleep(nanoseconds: 2_000_000_000)
            } catch {
                print("🛑 Guest: Polling cancelled")
                return
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func clearInsights() {
        insights = []
        analysisProgress = ""
        analysisError = nil
    }
}
