//
//  ContentView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 27/10/25.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {}) {
                Text("Create room")
                    .frame(maxWidth: .infinity)
            }
            .primaryButton()
            Button(action: {}) {
                Text("Join room")
                    .frame(maxWidth: .infinity)
            }
            .secondaryButton()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
