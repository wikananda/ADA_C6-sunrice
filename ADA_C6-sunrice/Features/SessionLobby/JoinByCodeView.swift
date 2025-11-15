//
//  JoinByCodeView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct JoinByCodeView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var vm = JoinByCodeViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            // Header
            HStack {
                BackButton(action: { dismiss() })
                Spacer()
                Text("Join a Session")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundStyle(AppColor.Primary.gray)
                Spacer()
                Color.clear
                    .frame(maxWidth: 40, maxHeight: 1)
            }
            
            Text("Do you have \na session code?")
                .font(.custom("Manrope", size: 24))
                .fontWeight(.bold)
                .foregroundStyle(AppColor.Primary.gray)
            
            Spacer()
            
            // Code input
            VStack (alignment: .center) {
                ZStack (alignment: .center) {
                    if vm.sessionCode.isEmpty {
                        Text("Enter the 6-digit code")
                            .font(.custom("Manrope", size: 32))
                            .fontWeight(.black)
                            .foregroundStyle(AppColor.blue10)
                    }

                    TextField("", text: $vm.displayCode)
                        .multilineTextAlignment(.center)
                        .keyboardType(.numberPad)
                        .font(.custom("Manrope", size: 64))
                        .fontWeight(.black)
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
    JoinByCodeView()
}
