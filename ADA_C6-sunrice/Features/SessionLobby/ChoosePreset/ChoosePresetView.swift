//
//  ChoosePresetView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct ChoosePresetView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title
            VStack(alignment: .leading, spacing: 8) {
                Text("Pick a color flow for your session")
                    .font(.titleSM)
                    .foregroundColor(AppColor.Primary.gray)
                Text("Each flow shapes how your team will explore ideas. You can start simple — more strategies will arrive soon.")
                    .font(.bodySM)
                    .foregroundColor(AppColor.Primary.gray)
            }
            
            // Presets
            VStack(alignment: .leading, spacing: 16) {
                Presets(
                    title: "Initial Ideas",
                    description: "A short, balanced rhythm for fast reflection",
                    duration: "30 min",
                    numOfRounds: 6,
                    sequence: ["w", "g", "g", "y", "b", "r"],
                    overview: "A complete ideation journey — from understanding the facts to exploring ideas, spotting opportunities, and reflecting on their impact.",
                    bestFor: ["Workshops", "Brainstorms", "Early exploration"],
                    outcome: "A well-rounded view of the topic — clear facts, expanded ideas, bright opportunities, grounded risks, and emotional perspectives."
                )
                Presets(
                    title: "Quick Feedback",
                    description: "A short, balanced rhythm for fast reflection",
                    duration: "30 min",
                    numOfRounds: 6,
                    sequence: ["y", "b", "r"],
                    overview: "A short, focused rhythm for team reflection and feedback. Moves quickly from what works, to what could improve, to how it feels overall.",
                    bestFor: ["Design critiques", "Check-ins", "Project reviews"],
                    outcome: "Clear highlights, constructive challenges, and human responses that capture the team’s overall sentiment."
                )
                TBAPreset(title: "Identifying Solutions")
                TBAPreset(title: "Strategic Planning")
            }
        }
    }
}

#Preview {
    ChoosePresetView()
}
