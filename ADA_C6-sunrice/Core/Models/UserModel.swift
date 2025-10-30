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
    
    public init(id: UUID = UUID(), username: String) {
        self.id = id
        self.username = username
    }
}
