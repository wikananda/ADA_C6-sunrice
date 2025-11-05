//
//  ModelEnum.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

enum CommentType: String, Codable, CaseIterable, Sendable {
    case red = "red", yellow = "yellow", black = "black"
}

enum ParticipantRole: String, Codable, CaseIterable, Sendable {
    case host = "host", participant = "participant"
}

enum RoomState: String, Codable, CaseIterable, Sendable {
    case lobby = "lobby", green = "green", yellow = "yellow", red = "red", white = "white", black = "black", end = "end"
}

enum UserStatus: String, Codable, CaseIterable, Sendable {
    case guest = "guest", logged = "logged"
}
