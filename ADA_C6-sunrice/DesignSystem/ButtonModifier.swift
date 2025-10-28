//
//  PrimaryButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftUI

private struct PrimaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Capsule())
            .frame(maxWidth: .infinity)
            .bold(true)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .clipShape(Capsule())
    }
}

private struct SecondaryButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .contentShape(Capsule())
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.blue)
            .background(Color.white)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}

extension View {
    func primaryButton() -> some View {
        modifier(PrimaryButtonModifier())
    }
    
    func secondaryButton() -> some View {
        modifier(SecondaryButtonModifier())
    }
}
