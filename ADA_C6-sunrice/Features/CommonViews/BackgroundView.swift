//
//  BackgroundView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 09/11/25.
//
import SwiftUI

struct BackgroundView: View {
    var body: some View {
        ZStack {
            Image("Union1")
                .padding(.leading, -150)
                .padding(.top, 550)
            Image("Union2")
                .padding(.trailing, -100)
                .padding(.top, 600)
        }
    }
}

#Preview {
    BackgroundView()
}
