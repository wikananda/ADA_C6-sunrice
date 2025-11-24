//
//  EnterSessionName.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct EnterNameView: View {
    @ObservedObject var vm: EnterNameViewModel
    @FocusState private var isFocused: Bool

    init(vm: EnterNameViewModel) {
        self.vm = vm
    }
    
    var body: some View {
        VStack (alignment: .leading, spacing: 20) {
            
            Text("What would you prefer \n to be called?")
                .font(.titleMD)
                .foregroundStyle(AppColor.Primary.gray)
            
            Spacer()
            
            // Code input
            VStack (alignment: .leading) {
                ZStack (alignment: .leading) {
                    if vm.username.isEmpty {
                        Text("e.g., Michael")
                            .font(.inputXL)
                            .foregroundStyle(AppColor.blue10)
                    }

                    TextField("", text: $vm.username)
                        .multilineTextAlignment(.leading)
                        .font(.inputXXL)
                        .foregroundStyle(AppColor.Primary.gray)
                        .disableAutocorrection(true)
                        .focused($isFocused)
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
        .onTapToDismissKeyboard()
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                isFocused = true
            }
        }
    }
}

#Preview {
    EnterNameView(vm: EnterNameViewModel())
}
