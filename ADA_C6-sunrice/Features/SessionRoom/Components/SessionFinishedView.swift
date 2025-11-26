//
//  SessionFinishedView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 26/11/25.
//

import SwiftUI
import Lottie

struct SessionFinishedView: View {
    var body: some View {
        VStack (spacing: 24) {
            Spacer()
            VStack (spacing: 8) {
                Text("Session Finished!")
                    .font(.titleMD)
                Text("Lets see how everything went")
                    .font(.bodySM)
            }
            
            LottieView(name: "splash_animation", loopMode: .loop)
                .frame(width: 350, height: 350)
            
            Spacer()
            AppButton(title: "NEXT") {}
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Background())
    }
}

#Preview {
    SessionFinishedView()
}
