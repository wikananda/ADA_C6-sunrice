//
//  ModelEnum.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

enum CommentType: String, Codable, CaseIterable, Sendable {
    case red, yellow, black
}

enum ParticipantRole: String, Codable, CaseIterable, Sendable {
    case host, participant
}

enum SessionState: String, Codable, CaseIterable, Sendable {
    case lobby, green, yellow, red, white, black, end
}
