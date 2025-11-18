//
//  EnterSessionNameViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 16/11/25.
//

import SwiftUI
import Combine

@MainActor
final class EnterNameViewModel: ObservableObject {
    @Published var username: String = ""
    
    var isValid: Bool {
        !username.isEmpty
    }
    
    func goToLobby() {
        print("Going to lobby as user: \(username)")
    }
}
