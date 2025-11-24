//
//  LocalIdea.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import Foundation

struct LocalIdea: Identifiable {
    let id: UUID
    let text: String
    let typeId: Int64
    var isUploaded: Bool = false
    
    init(text: String, typeId: Int64) {
        self.id = UUID()
        self.text = text
        self.typeId = typeId
    }
}

struct LocalComment: Identifiable {
    let id: UUID
    let ideaId: Int64  // Server idea ID
    let text: String
    let typeId: Int64
    var isUploaded: Bool = false
    
    init(ideaId: Int64, text: String, typeId: Int64) {
        self.id = UUID()
        self.ideaId = ideaId
        self.text = text
        self.typeId = typeId
    }
}
