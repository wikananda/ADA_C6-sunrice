//
//  IdeaInsightDTO.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 26/11/25.
//

import Foundation

struct EvidenceItem: Codable {
    let id: Int
    let text: String
}

struct IdeaInsightEvidence: Codable {
    let prosIds: [EvidenceItem]?
    let risksIds: [EvidenceItem]?
    let whiteFactsIds: [EvidenceItem]?
    
    enum CodingKeys: String, CodingKey {
        case prosIds = "pros_ids"
        case risksIds = "risks_ids"
        case whiteFactsIds = "white_facts_ids"
    }
}

struct IdeaInsightDTO: Codable, Identifiable {
    let id: Int64
    let ideaId: Int64
    let sessionId: Int64
    let rating: String  // "good", "neutral", "risky"
    let why: String
    let evidence: IdeaInsightEvidence
    let mitigations: [String]?  // Array of mitigation strings
    let worstPossibleIdea: String?
    let flipSideIdea: String?
    let notes: [String]?  // Array of note strings
    
    enum CodingKeys: String, CodingKey {
        case id, rating, why, evidence, mitigations, notes
        case ideaId = "idea_id"
        case sessionId = "session_id"
        case worstPossibleIdea = "worst_possible_idea"
        case flipSideIdea = "flip_side_idea"
    }
}

struct AnalyzeIdeaResponse: Codable {
    let success: Bool
    let insight: IdeaInsightDTO
    let summaryId: Int64?
    
    enum CodingKeys: String, CodingKey {
        case success, insight
        case summaryId = "summary_id"
    }
}
