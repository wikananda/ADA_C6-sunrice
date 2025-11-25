//
//  SummaryDTO.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 25/11/25.
//

// Ideas summarization and category
struct IdeaSummary: Decodable {
    struct Item: Decodable {
        let id: Int
        let fact: String
    }

    struct Theme: Decodable {
        let name: String
        let summary: String
        let items: [Item]
    }

    let themes: [Theme]
    let notes: String?
}

struct SummarizeSessionResponse<Summary: Decodable>: Decodable {
    let success: Bool
    let sessionType: String
    let summary: Summary
    let summaryId: Int?

    private enum CodingKeys: String, CodingKey {
        case success
        case sessionType = "session_type"
        case summary
        case summaryId = "summary_id"
    }
}
