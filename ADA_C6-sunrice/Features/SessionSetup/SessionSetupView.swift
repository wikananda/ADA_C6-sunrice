//
//  SessionSetupView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 18/11/25.
//

import SwiftUI

struct SessionSetupView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = SessionSetupViewModel()
    
    var body: some View {
        VStack {
            Stepper(totalSteps: 3, currentSteps: vm.step.rawValue, horizontalPadding: 24)
                .frame(height: 24)
                .padding(.top)
            
            ScrollView {
                switch vm.step {
                case .defineSession:
                    DefineSessionView(vm: vm)
                case .selectPreset:
                    SelectPresetView(vm: vm)
                case .reviewSession:
                    ReviewSessionView(vm: vm)
                }
            }
            .padding()
            
            HStack(spacing: 16) {
                AppButton(title: vm.buttonText) {
                    if vm.step == .reviewSession {
                        // go to lobby
                    } else {
                        vm.nextStep()
                    }
                }
                .disabled(vm.isNextButtonDisabled)
            }
            .padding()
        }
    }
}

#Preview {
    SessionSetupView()
}
