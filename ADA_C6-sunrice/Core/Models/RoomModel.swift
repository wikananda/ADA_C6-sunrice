//
//  RoomModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftData
import Foundation

@Model
final class RoomModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var name: String?
    var state: RoomState
    
    @Relationship var createdBy: UserModel?
    var createdAt: Date
    
    @Attribute(.unique) public var code: String {
        didSet { code = code.uppercased() }
    }
    
    public var updatedAt: Date
    
    @Relationship(inverse: \RoomParticipantModel.room) public var participants: [RoomParticipantModel] = []
    
    public init(
        id: UUID = UUID(),
        name: String?,
        state: RoomState = .lobby,
        createdBy: UserModel? = nil,
        createdAt: Date = .now,
        code: String,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.state = .lobby
        self.createdBy = createdBy
        self.createdAt = createdAt
        self.code = code.uppercased()
        self.updatedAt = updatedAt
    }
}

struct RoomDTO: Codable, Sendable {
    var id: UUID
    var name: String?
    var state: String
    var code: String
    var created_by: UUID?
    var created_at: Date
    var updated_at: Date
}

private extension RoomDTO {
    func toModel(in context: ModelContext, createdBy: UserModel? = nil) -> RoomModel {
        let model = RoomModel(
            id: id,
            name: name,
            state: RoomState(rawValue: state) ?? .lobby,
            createdBy: createdBy,
            createdAt: created_at,
            code: code,
            updatedAt: updated_at
        )
        context.insert(model)
        return model
    }
}
