//
//  SessionFinishedView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 26/11/25.
//

import SwiftUI
import Lottie

struct SessionFinishedView: View {
    @ObservedObject var vm: SessionRoomViewModel
    
    var body: some View {
        VStack (spacing: 24) {
            Spacer()
            
            VStack (spacing: 8) {
                Text("Session Finished!")
                    .font(.titleMD)
                Text("Lets see how everything went")
                    .font(.bodySM)
            }
            if vm.isAnalyzingIdeas {
                VStack(spacing: 16) {
                    ProgressView()
                        .scaleEffect(1.5)
                    
                    Text(vm.analysisProgress)
                        .font(.titleSSM)
                    
                    Text("Please wait...")
                        .font(.bodySM)
                        .foregroundColor(.secondary)
                }
            } else {
                Text("Analysis Complete!")
                    .font(.titleSSM)
            }
            
            LottieView(name: "splash_animation", loopMode: .loop)
                .frame(width: 350, height: 350)
            
            Spacer()
            
            if !vm.isAnalyzingIdeas {
                AppButton(title: "NEXT") {
                    vm.navigateToFinalSummary()
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Background())
        .onAppear {
            if !vm.hasFetchedInsights {
                Task {
                    await vm.analyzeIdeas()
                }
            }
        }
    }
}

#Preview {
    // Preview requires a mock ViewModel
    Text("SessionFinishedView Preview - Requires ViewModel")
}
