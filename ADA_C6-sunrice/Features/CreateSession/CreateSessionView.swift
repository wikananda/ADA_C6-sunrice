//
//  CreateSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 19/11/25.
//

import SwiftUI

struct CreateSessionView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = CreateSessionViewModel()
    var body: some View {
        VStack {
            Header(
                config: .init(title: vm.currentTitle),
                onBack: { vm.handleBack(dismiss: { dismiss() }) }
            )
            
            if (vm.step.rawValue > 1 && vm.step.rawValue < 5) {
                Stepper(totalSteps: 3, currentSteps: vm.step.rawValue - 1, horizontalPadding: 24)
                    .frame(height: 24)
            }
            
            GeometryReader { proxy in
                ScrollView {
                    stepContent
                        .frame(maxWidth: .infinity)
                        .frame(minHeight: proxy.size.height, alignment: .top)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            AppButton(title: vm.buttonText) {
                vm.handleNext()
            }
            .disabled(vm.isNextButtonDisabled)
        }
        .padding(.horizontal)
        .padding(.bottom)
        
    }
    
    @ViewBuilder
    private var stepContent: some View {
        switch vm.step {
        case .enterName:
            EnterNameView(vm: vm.nameVM)
        case .defineSession:
            DefineSessionView(vm: vm)
        case .selectPreset:
            SelectPresetView(vm: vm)
        case .reviewSession:
            ReviewSessionView(vm: vm)
        default:
            SessionLobbyView(
                participants: vm.makeParticipants()
            )
        }
    }
}

#Preview {
    CreateSessionView()
}
