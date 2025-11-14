//
//  OnboardingBGView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct OnboardingView: View {
    var body: some View {
        ZStack {
            Image(.background)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()
            VStack {
                OnboardingPage1View()
                Button(action: {}) {
                    Text("Continue")
                }
                .primaryButton()
            }
            .padding(24)
        }
    }
}

#Preview {
    OnboardingView()
}
