//
//  ReviewSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct ReviewSessionView: View {
    @State var minutesPerRound: Int = 5
    var body: some View {
        VStack (alignment: .leading, spacing: 16) {
            // Title
            Text("Review and start your session")
                .font(.titleSM)
                .foregroundColor(AppColor.Primary.gray)
            
            // Chosen presets
            SelectedPreset(
                title: "Initial Ideas",
                description: "A short, balanced rhythm for fast reflection.",
                showStats: false,
                numOfRounds: 6,
                sequence: ["w", "g", "g", "y", "b", "r"],
            )
            
            // Select duration
            DurationSelector(minutesPerRound: $minutesPerRound)
            Text("Shorter rounds keep energy high; you can always add more time during the session.")
                .font(.bodySM)
                .foregroundColor(AppColor.grayscale40)
            
            VStack(alignment: .leading, spacing: 8) {
                Label("About Private Mode", systemImage: "info.circle")
                    .font(.labelMD)
                Text("Anonymity is always on — names will disappear once the session begins.")
                    .font(.bodySM)
            }
            .foregroundColor(AppColor.Primary.gray)
        }
    }
}

#Preview {
    ReviewSessionView()
}
