//
//  PresetModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftData
import Foundation

@Model
final class PresetModel: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    
    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}
