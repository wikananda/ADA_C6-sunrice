//
//  JoinSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct JoinSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = JoinSessionViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Header(
                config: .init(title: vm.currentTitle),
                onBack: { vm.handleBack(dismiss: { dismiss() }) }
            )
            
            stepContent
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal)
        .animation(.easeInOut, value: vm.step)
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch vm.step {
        case .enterCode:
            EnterSessionCodeView(vm: vm.codeVM) {
                vm.advanceToName()
            }
        case .enterName:
            EnterNameView(vm: vm.nameVM) {
                vm.advanceToLobby()
            }
        case .lobby:
            SessionLobbyView(
                participants: vm.makeParticipants(),
                code: vm.code
            )
        }
    }
}

#Preview {
    JoinSessionView()
}
