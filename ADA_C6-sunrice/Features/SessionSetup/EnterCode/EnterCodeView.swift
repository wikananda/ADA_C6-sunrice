//
//  JoinByCodeView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct EnterCodeView: View {
    @ObservedObject var vm: EnterCodeViewModel
    @FocusState private var isFocused: Bool

    init(vm: EnterCodeViewModel) {
        self.vm = vm
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
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFocused = true
            }
        }
    }
}

#Preview {
    EnterCodeView(vm: EnterCodeViewModel())
}
