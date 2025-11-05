//
//  RoomParticipantModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftData
import Foundation

@Model
final class RoomParticipantModel: Identifiable {
    @Relationship public var room: RoomModel
    @Relationship public var user: UserModel
    public var role: ParticipantRole
    
    @Attribute(.unique) public var uniqueKey: String
    
    
    public init(
        id: UUID = UUID(),
        room: RoomModel,
        user: UserModel,
        role: ParticipantRole
    ) {
        self.room = room
        self.user = user
        self.role = role
        self.uniqueKey = Self.composeUniqueKey(roomID: room.id, userID: user.id)
    }
    
    public func refreshUniqueKey() {
        uniqueKey = Self.composeUniqueKey(roomID: room.id, userID: user.id)
    }
    
    private static func composeUniqueKey(roomID: UUID, userID: UUID) -> String {
        roomID.uuidString + ":" + userID.uuidString
    }
}
