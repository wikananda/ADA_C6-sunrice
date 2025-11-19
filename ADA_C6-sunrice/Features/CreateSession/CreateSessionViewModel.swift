//
//  CreateSessionViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 19/11/25.
//

import SwiftUI
import Combine

enum CreateSessionStep: Int, CaseIterable {
    case enterName = 1
    case defineSession
    case selectPreset
    case reviewSession
    case lobby
    
    var title: String {
        if self == .lobby {
            return "Session Lobby"
        } else {
            return "Session Setup"
        }
    }
}

@MainActor
final class CreateSessionViewModel: ObservableObject {
    var currentTitle: String { step.title }
    
    // MARK: Enter Name
    let nameVM = EnterNameViewModel()
    private var cancellables = Set<AnyCancellable>()
    init() {
        // Forward changes from child VM to parent's view
        nameVM.objectWillChange
            .sink{ [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
    }
    
    @Published var step: CreateSessionStep = .enterName
    
    // MARK: Define Session
    @Published var title: String = ""
    @Published var description: String = ""
    
    // MARK: Select Presets
    @Published var selectedPreset: SessionPreset? = nil
    let presets: [SessionPreset] = [
        SessionPreset(
            title: "Initial Ideas",
            description: "A short, balanced rhythm for fast reflection",
            duration: "30 min",
            numOfRounds: 6,
            sequence: ["w", "g", "g", "y", "b", "r"],
            overview: "A complete ideation journey — from understanding the facts to exploring ideas, spotting opportunities, and reflecting on their impact.",
            bestFor: ["Workshops", "Brainstorms", "Early exploration"],
            outcome: "A well-rounded view of the topic — clear facts, expanded ideas, bright opportunities, grounded risks, and emotional perspectives."
        ),
        SessionPreset(
            title: "Quick Feedback",
            description: "A short, balanced rhythm for fast reflection",
            duration: "30 min",
            numOfRounds: 6,
            sequence: ["y", "b", "r"],
            overview: "A short, focused rhythm for team reflection and feedback. Moves quickly from what works, to what could improve, to how it feels overall.",
            bestFor: ["Design critiques", "Check-ins", "Project reviews"],
            outcome: "Clear highlights, constructive challenges, and human responses that capture the team’s overall sentiment."
        )
    ]
    let tbaPresets: [TBASessionPreset] = [
        TBASessionPreset(title: "Identifying Solutions"),
        TBASessionPreset(title: "Strategic Planning")
    ]
    
    // MARK: Review Session
    @Published var minutesPerRound: Int = 5
    
    // MARK: Button Behavior
    var buttonText: String {
        switch step {
        case .enterName:
            return "Continue"
        case .defineSession:
            return "Next — Choose a Flow"
        case .selectPreset:
            return "Next — Review Session"
        case .reviewSession:
            return "Go to Lobby"
        case .lobby:
            return "Start Session"
        }
    }
    
    var isNextButtonDisabled: Bool {
        switch step {
        case .defineSession:
            return title.isEmpty
        case .selectPreset:
            return selectedPreset == nil
        case .reviewSession:
            return false
        case .enterName, .lobby:
            return false
        }
    }
    
    // MARK: Functions
    func handleBack(dismiss: () -> Void) {
        guard let previous = CreateSessionStep(rawValue: step.rawValue - 1) else {
            dismiss()
            return
        }
        withAnimation { step = previous }
    }
    
    func handleNext() {
        guard let next = CreateSessionStep(rawValue: step.rawValue + 1) else { return }
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

