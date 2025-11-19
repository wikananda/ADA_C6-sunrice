//
//  SessionSetupViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 19/11/25.
//

import SwiftUI
import Combine

enum SessionSetupStep: Int, CaseIterable {
    case defineSession = 1
    case selectPreset
    case reviewSession
}

struct SessionPreset: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let duration: String
    let numOfRounds: Int
    let sequence: [String]
    let overview: String
    let bestFor: [String]
    let outcome: String
}

struct TBASessionPreset: Identifiable, Equatable {
    let id = UUID()
    let title: String
}

@MainActor
final class SessionSetupViewModel: ObservableObject {
    @Published var step: SessionSetupStep = .defineSession
    
    // Define Session
    @Published var title: String = ""
    @Published var description: String = ""
    
    // Select Preset
    @Published var selectedPreset: SessionPreset?
    
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
    
    // Review Session
    @Published var minutesPerRound: Int = 5
    
    var buttonText: String {
        switch step {
        case .defineSession:
            return "Next — Choose a Flow"
        case .selectPreset:
            return "Next — Review Session"
        case .reviewSession:
            return "Go to Lobby"
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
        }
    }
    
    
    func nextStep() {
        withAnimation {
            if step == .defineSession {
                step = .selectPreset
            } else if step == .selectPreset {
                step = .reviewSession
            }
        }
    }
    
    func previousStep() {
        withAnimation {
            if step == .selectPreset {
                step = .defineSession
            } else if step == .reviewSession {
                step = .selectPreset
            }
        }
    }
    
}
