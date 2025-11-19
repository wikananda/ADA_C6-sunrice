//
//  JoinSessionViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 19/11/25.
//

import SwiftUI
import Combine

enum JoinSessionStep: Int, CaseIterable {
    case enterCode = 1
    case enterName
    case lobby
    
    var title: String {
        switch self {
        case .enterCode: return "Join a Session"
        case .enterName: return "Join a Session"
        case .lobby: return "Session Lobby"
        }
    }
}

@MainActor
final class JoinSessionViewModel: ObservableObject {
    let codeVM = EnterSessionCodeViewModel()
    let nameVM = EnterNameViewModel()
    
    var currentTitle: String { step.title }
    var code: String { codeVM.sessionCode }
    @Published var step: JoinSessionStep = .enterCode
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Forward changes from child VM to ensure the parent view updates if needed
        codeVM.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
            
        nameVM.objectWillChange
            .sink { [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    var isNextButtonDisabled: Bool {
        switch step {
        case .enterCode:
            return !codeVM.isValidCode
        case .enterName:
            return !nameVM.isValid
        case .lobby:
            return true
        }
    }
    
    
    func handleBack(dismiss: () -> Void) {
        guard let previous = JoinSessionStep(rawValue: step.rawValue - 1) else {
            dismiss()
            return
        }
        withAnimation { step = previous }
    }
    
    func handleNext() {
        guard let next = JoinSessionStep(rawValue: step.rawValue + 1) else { return }
        withAnimation { step = next }
    }
    
    func makeParticipants() -> [String] {
        var base = ["Saskia", "Selena", "Hendy", "Richard"]
        if !nameVM.username.isEmpty {
            base.insert(nameVM.username, at: 0)
        }
        return base
    }
}
