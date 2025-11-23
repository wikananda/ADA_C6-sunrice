//
//  SessionRoomDTOs.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import Foundation

struct SequenceDTO: Decodable, Sendable {
    let id: Int64
    let mode_id: Int64?
    let first_round: Int64?
    let second_round: Int64?
    let third_round: Int64?
    let fourth_round: Int64?
    let fifth_round: Int64?
    let sixth_round: Int64?
    
    enum CodingKeys: String, CodingKey {
        case id, mode_id
        case first_round = "1st_round"
        case second_round = "2nd_round"
        case third_round = "3rd_round"
        case fourth_round = "4th_round"
        case fifth_round = "5th_round"
        case sixth_round = "6th_round"
    }
}

struct IdeaDTO: Codable, Sendable, Identifiable {
    let id: Int64
    let text: String?
    let type_id: Int64?
    let session_id: Int64?
    let user_id: Int64?
    let created_at: Date?
}

struct IdeaCommentDTO: Codable, Sendable, Identifiable {
    let id: Int64
    let idea_id: Int64?
    let text: String?
    let user_id: Int64?
    let created_at: Date?
}

struct TypeDTO: Codable, Sendable, Identifiable {
    let id: Int64
    let name: String?
}

struct InsertIdeaParams: Encodable, Sendable {
    let text: String
    let type_id: Int64
    let session_id: Int64
    let user_id: Int64
}

struct InsertCommentParams: Encodable, Sendable {
    let idea_id: Int64
    let text: String
    let user_id: Int64
}
