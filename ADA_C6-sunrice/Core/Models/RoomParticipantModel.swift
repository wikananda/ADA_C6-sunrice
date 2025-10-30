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
    @Attribute(.unique) var id: UUID
    @Relationship(inverse: \RoomModel.id) var room: RoomModel
    @Relationship(inverse: \UserModel.id) var user: UserModel
    var role: ParticipantRole
    
    public init(
        id: UUID = UUID(),
        room: RoomModel,
        user: UserModel,
        role: ParticipantRole
    ) {
        self.id = id
        self.room = room
        self.user = user
        self.role = role
    }
}
