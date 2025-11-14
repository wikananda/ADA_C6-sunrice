//
//  OnboardingBGView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject private var vm = OnboardingViewModel(totalPages: 3)
    var onFinish: () -> Void = {}
    
    var body: some View {
        ZStack {
            // Background
            Image(.background)
                .resizable()
                .ignoresSafeArea()
                .scaledToFill()

            // Content
            VStack(spacing: 16) {
                // Header
                HStack {
                    BackButton { withAnimation { vm.back() } }
                    .opacity(vm.canGoBack ? 1 : 0)
                    Spacer()
                    SkipButton(action: { vm.skipToEnd() })
                }
                
                // Content
                TabView(selection: $vm.page) {
                    OnboardingPage1View()
                        .tag(0)
                    OnboardingPage2View()
                        .tag(1)
                    OnboardingPage3View()
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Stepper indicators
                HStack(spacing: 8) {
                    ForEach(0..<vm.totalPages, id: \.self) { idx in
                        if idx == vm.page {
                            Capsule()
                                .fill(Color.primary)
                                .frame(width: 24, height: 8)
                        } else {
                            Circle()
                                .fill(Color.primary.opacity(0.2))
                                .frame(width: 8, height: 8)
                        }
                    }
                }

                // Controls
                Spacer(minLength: 0)
                AppButton(title: vm.primaryButtonTitle) {
                    withAnimation { vm.next() }
                }
            }
            .padding(24)
        }
        .onChange(of: vm.didFinish) { _, newValue in
            if newValue { onFinish() }
        }
    }
}

#Preview {
    OnboardingView()
}
