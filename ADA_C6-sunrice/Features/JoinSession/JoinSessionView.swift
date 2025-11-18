//
//  JoinSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

private enum JoinSessionStep: Int, CaseIterable {
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

struct JoinSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var codeVM = EnterSessionCodeViewModel()
    @StateObject private var nameVM = EnterNameViewModel()
    @State private var step: JoinSessionStep = .enterCode
    
    private var totalSteps: Int { JoinSessionStep.allCases.count }
    
    var body: some View {
        VStack(spacing: 24) {
            Header(
                config: .init(title: step.title),
                onBack: step == .enterCode ? { dismiss() } : { handleBack() }
            )
            
            stepContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal)
        .animation(.easeInOut, value: step)
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch step {
        case .enterCode:
            EnterSessionCodeView(vm: codeVM) {
                withAnimation { step = .enterName }
            }
        case .enterName:
            EnterNameView(vm: nameVM) {
                withAnimation { step = .lobby }
            }
        case .lobby:
            SessionLobbyView(
                participants: makeParticipants(),
                code: codeVM.formattedCode
            )
        }
    }
    
    private func handleBack() {
        guard let previous = JoinSessionStep(rawValue: step.rawValue - 1) else {
            dismiss()
            return
        }
        withAnimation { step = previous }
    }
    
    private func makeParticipants() -> [String] {
        var base = ["Saskia", "Selena", "Hendy", "Richard"]
        if !nameVM.username.isEmpty {
            base.insert(nameVM.username, at: 0)
        }
        return base
    }
}

#Preview {
    JoinSessionView()
}
