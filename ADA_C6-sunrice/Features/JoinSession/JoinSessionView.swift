//
//  JoinSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct JoinSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var navVM: NavigationViewModel
    @StateObject private var vm = JoinSessionViewModel()
    
    var body: some View {
        VStack(spacing: 24) {
            Header(
                config: .init(title: vm.currentTitle),
                onBack: { vm.handleBack(dismiss: { dismiss() }) }
            )
            
            GeometryReader { proxy in
                ScrollView {
                    stepContent
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: proxy.size.height, alignment: .top)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            if (vm.step != .lobby) {
                AppButton(title: "Continue") {
                    vm.handleNext()
                }
                .disabled(vm.isNextButtonDisabled)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .padding(.horizontal)
        .padding(.bottom)
        .animation(.easeInOut, value: vm.step)
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch vm.step {
        case .enterCode:
            EnterCodeView(vm: vm.codeVM)
        case .enterName:
            EnterNameView(vm: vm.nameVM)
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
