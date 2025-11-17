//
//  PrimaryButton.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 28/10/25.
//
/// THIS FILE IS TO BE DEPRECATED

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

struct PrimaryButtonActive: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 48)
            .padding(.vertical, 24)
            .frame(width: 360, height: 64, alignment: .center)
            .background(Color(red: 0.05, green: 0.1, blue: 0.23))
            .foregroundColor(.white)
            .cornerRadius(99)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}

struct PrimaryButtonDisabled: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding(.horizontal, 48)
            .padding(.vertical, 24)
            .frame(width: 360, height: 64, alignment: .center)
            .background(Color(red: 0.83, green: 0.83, blue: 0.85))
            .foregroundColor(.white)
            .cornerRadius(99)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
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
