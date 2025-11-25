//
//  PreparingSessionLS.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 23/11/25.
//

import SwiftUI

struct PreparingLoadingScreen: View {
    var body: some View {
        VStack(spacing: 24) {
            VStack {
                Image(.lsPreparing)
                    .resizable()
                    .scaledToFit()
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
        .frame(maxWidth: .infinity)
        .background(Background())
    }
}

#Preview {
    PreparingLoadingScreen()
}
