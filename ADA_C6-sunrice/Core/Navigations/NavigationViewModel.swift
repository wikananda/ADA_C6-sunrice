//
//  NavigationViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 04/11/25.
//

import SwiftUI
import Combine

class NavigationViewModel: ObservableObject {
    @Published var path = NavigationPath()
    
    func goToCreateRoom() {
        path.append(Route.create)
    }
    
    func goToJoinRoom() {
        path.append(Route.join)
    }
    
    func goToRoomLobby(id: String, name: String? = nil) {
        path.append(Route.room(id: id, name: name))
    }
}
