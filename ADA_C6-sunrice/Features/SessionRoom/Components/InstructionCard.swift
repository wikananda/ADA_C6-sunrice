//
//  InstructionCard.swift
//  ADA_C6-sunrice
//
//  Created by Hanna Nadia Savira on 23/11/25.
//

import SwiftUI

struct InstructionCard: View {
    let instruction: SessionInstruction
    let onTap: () -> Void

    var body: some View {
        ZStack {
            Color.black
                .opacity(0.5)
                .ignoresSafeArea()
            VStack(spacing: 43) {
                VStack(spacing: 52) {
                    VStack(spacing: 8) {
                        Text("Instruction")
                            .font(.titleLG)
                        Text(instruction.subtitle)
                            .multilineTextAlignment(.center)
                    }
                    // TODO: remove rectangle, uncomment image
                    Image(instruction.mascot)
                        .frame(width: 240, height: 240)
                    Text(instruction.body)
                        .multilineTextAlignment(.center)
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 20))
            }
            .padding()
            VStack {
                Spacer()
                AppButton(title: "LET'S GO", action: onTap)
                    .padding(.horizontal, 16)
            }
            .padding(.horizontal)
        }
        .onTapToDismissKeyboard()
    }
}
