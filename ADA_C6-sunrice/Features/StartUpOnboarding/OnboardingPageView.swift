//
//  OnboardingPageView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 14/11/25.
//

import SwiftUI

struct OnboardingPage1View: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                VStack {
                    Image(.group1)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                .frame(height: 450)
                VStack(spacing: 20) {
                    Text("Welcome to WAIS")
                        .font(.custom("Manrope", size: 24)).fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppColor.Primary.gray)
                    Text("Here, structure meets flow.\nEach session helps every voice be heard equally — clear, focused, and free from bias.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .foregroundStyle(AppColor.Primary.gray)
                }
            }
        }
    }
}

struct OnboardingPage2View: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                VStack {
                    Image(.group2)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                .frame(height: 450)
                VStack(spacing: 20) {
                    Text("Think in color, \none focus at a time")
                        .font(.custom("Manrope", size: 24)).fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppColor.Primary.gray)
                    Text("WAIS leads you through a color flow — a sequence of guided color rounds that represents a different way of thinking. \nTogether, they turn group thinking into rhythm and clarity.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .foregroundStyle(AppColor.Primary.gray)

                }
            }
        }
    }
}

struct OnboardingPage3View: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            VStack {
                VStack {
                    Image(.group3)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 250, height: 250)
                }
                .frame(height: 450)
                VStack(spacing: 20) {
                    Text("Ready to begin \nyour first flow?")
                        .font(.custom("Manrope", size: 24)).fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .foregroundStyle(AppColor.Primary.gray)
                    Text("You’re about to enter a guided rhythm of thinking — calm, structured, and collective. \nStep into the first color flow and let ideas unfold naturally.")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 12))
                        .fontWeight(.light)
                        .foregroundStyle(AppColor.Primary.gray)

                }
            }
        }
    }
}
