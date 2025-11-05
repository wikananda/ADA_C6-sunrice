//
//  UserModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftData
import Foundation

@Model
final class UserModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var username: String
    var createdAt: Date
    var status: UserStatus
    
    @Relationship(inverse: \RoomModel.createdBy) public var createdRooms: [RoomModel] = []
    @Relationship(inverse: \RoomParticipantModel.user) public var participantOf: [RoomParticipantModel] = []
    
    
    public init(id: UUID = UUID(), username: String, createdAt: Date = .now, status: UserStatus = .guest) {
        self.id = id
        self.username = username
        self.createdAt = createdAt
        self.status = status
    }
}
