//
//  PreparingSessionLS.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 23/11/25.
//

import SwiftUI
import Lottie

struct PreparingLoadingScreen: View {
    var body: some View {
        ZStack {
            Background()
            VStack(spacing: 24) {
                LottieView(name: "splash_animation", loopMode: .loop)
                    .frame(width: 350, height: 350)

                Text("Preparing your space for flow...")
                    .font(.titleSM)
                VStack {
                    Text("We’re aligning the rhythm and setting focus for the first color round.")
                        .font(.bodySM)
                        .multilineTextAlignment(.center)
                    Text("Take a breath — thinking begins in a moment.")
                        .font(.bodySM)
                        .multilineTextAlignment(.center)
                }
            }
            .frame(maxWidth: 360)
        }
    }
}

#Preview {
    PreparingLoadingScreen()
}
