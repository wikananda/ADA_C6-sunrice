//
//  TimesUpView.swift
//  ADA_C6-sunrice
//
//  Created by Hanna Nadia Savira on 23/11/25.
//

import SwiftUI

struct TimesUpView: View {
    var body: some View {
        ZStack {
            Background()
            VStack(spacing: 12) {
                Image(systemName: "clock")
                    .font(.system(size: 115))
                    .fontWeight(.ultraLight)
                VStack(spacing: 4) {
                    Text("TIME'S UP!!")
                        .font(.titleLG)
                    Text("LET'S SEE HOW YOU DID")
                }
            }
            .foregroundStyle(.blue50)
        }
        .background(.white)
    }
}
