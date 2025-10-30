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
    
    @Relationship var preset: PresetModel?
    @Relationship(inverse: \UserModel.id) var createdBy: UserModel?
    var state: SessionState
    var createdAt: Date
    var updatedAt: Date?
    
    public init(id: UUID = UUID(), name: String?, preset: PresetModel?, createdBy: UserModel?) {
        self.id = id
        if let name {
            self.name = name
        }
        if let preset {
            self.preset = preset
        }
        if let createdBy {
            self.createdBy = createdBy
        }
        self.state = .lobby
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}
