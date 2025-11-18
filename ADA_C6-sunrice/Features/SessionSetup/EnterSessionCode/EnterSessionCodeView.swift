//
//  JoinByCodeView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct EnterSessionCodeView: View {
    @ObservedObject var vm: EnterSessionCodeViewModel
    var onContinue: () -> Void
    @FocusState private var isFocused: Bool

    init(vm: EnterSessionCodeViewModel, onContinue: @escaping () -> Void = {}) {
        self.vm = vm
        self.onContinue = onContinue
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            
            Text("Do you have \na session code?")
                .font(.titleMD)
                .foregroundStyle(AppColor.Primary.gray)
            
            Spacer()
            
            // Code input
            VStack (alignment: .center) {
                ZStack (alignment: .center) {
                    if vm.sessionCode.isEmpty {
                        Text("Enter the 6-digit code")
                            .font(.inputXL)
                            .foregroundStyle(AppColor.blue10)
                    }

                    TextField("", text: $vm.displayCode)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .font(.inputXXL)
                        .foregroundStyle(AppColor.Primary.gray)
                        .disableAutocorrection(true)
                        .focused($isFocused)
                        .onChange(of: vm.displayCode) { _, newValue in
                            vm.handleDisplayChange(newValue)
                        }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    isFocused = true
                }
            }
            Spacer()
            AppButton(title: "Continue") {
                vm.joinRoom()
                onContinue()
            }
            .disabled(!vm.isValidCode)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFocused = true
            }
        }
    }
}

#Preview {
    EnterSessionCodeView(vm: EnterSessionCodeViewModel())
}
