//
//  PrimaryButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//

import SwiftUI

private struct PrimaryButtonModifier: ViewModifier {
    var color: Color = .blue
    func body(content: Content) -> some View {
        content
            .contentShape(Capsule())
            .frame(maxWidth: .infinity)
            .bold(true)
            .padding()
            .foregroundColor(.white)
            .background(color)
            .clipShape(Capsule())
    }
}

private struct SecondaryButtonModifier: ViewModifier {
    var color: Color = .white
    func body(content: Content) -> some View {
        content
            .contentShape(Capsule())
            .frame(maxWidth: .infinity)
            .padding()
            .foregroundColor(Color.blue)
            .background(color)
            .clipShape(Capsule())
            .overlay(
                Capsule()
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}

extension View {
    func primaryButton(color: Color = .blue) -> some View {
        modifier(PrimaryButtonModifier(color: color))
    }
    
    func secondaryButton(color: Color = .white) -> some View {
        modifier(SecondaryButtonModifier(color: color))
    }
}
