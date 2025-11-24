//
//  SessionRoom.swift
//  ADA_C6-sunrice
//
//  Created by Hanna Nadia Savira on 23/11/25.
//

struct SessionRoomPart {
    let title: String
    let type: MessageCardType
    var introduction: SessionIntroduction
    var instruction: SessionInstruction
}

struct SessionIntroduction {
    let title: String
    let mascot: String
}

struct SessionInstruction {
    let subtitle: String
    let body: String
    let mascot: String
}

enum SessionRoom {
    case fact, idea, buildon, benefit, risk, feeling

    var shared: SessionRoomPart {
        switch self {
        case .fact:
            return .init(
                title: "Facts & Info",
                type: .white,
                introduction: SessionIntroduction(
                    title: "Let’s Put Every Facts &\nInformation You Know",
                    mascot: "Mascot White"
                ),
                instruction: SessionInstruction(
                    subtitle:
                        "Let’s start by laying the foundation. Share facts, data, or real observations about the topic or idea.",
                    body:
                        "Keep it neutral, no opinions or guesses yet. The goal is to build a shared understanding before ideas start flowing.",
                    mascot: "Mascot White Alert"
                )
            )
        case .idea:
            return .init(
                title: "Idea",
                type: .green,
                introduction: SessionIntroduction(
                    title: "Let’s Generate\nSome Ideas!",
                    mascot: "Mascot Green",
                ),
                instruction: SessionInstruction(
                    subtitle:
                        "Time to create. Add new ideas, spark alternatives, or build on earlier insights.",
                    body:
                        "Time to create. Add new ideas, spark alternatives, or build on earlier insights.",
                    mascot: "Mascot Green Alert"
                )
            )
        case .buildon:
            return .init(
                title: "Build On the Ideas",
                type: .darkGreen,
                introduction: SessionIntroduction(
                    title: "Let’s Buil Upon \nThese Ideas!",
                    mascot: "Mascot Green",
                ),
                instruction: SessionInstruction(
                    subtitle:
                        "Time to build on each other! Explore possibilities and spark creativity",
                    body:
                        "Time to build on each other ideas! Try to diverge new possibilities and creativity.",
                    mascot: "Mascot Green Alert"
                )
            )
        case .benefit:
            return .init(
                title: "Benefits",
                type: .yellow,
                introduction: SessionIntroduction(
                    title: "Let’s Seek The\nBenefits of The Ideas",
                    mascot: "Mascot Yellow",
                ),
                instruction: SessionInstruction(
                    subtitle:
                        "Let’s look for the positives. Write down the potential benefits, values, or opportunities this idea brings.",
                    body:
                        "Focus on what could go right.\nNo need to repeat what’s already said, explore new angles of potential.",
                    mascot: "Mascot Yellow Alert"
                )
            )
        case .risk:
            return .init(
                title: "Risks",
                type: .black,
                introduction: SessionIntroduction(
                    title: "Let’s Analyze The\nRisks of The Ideas",
                    mascot: "Mascot Black",
                ),
                instruction: SessionInstruction(
                    subtitle:
                        "Point out the risks, weaknesses, or potential downsides of an idea, constructively.",
                    body:
                        "Think critically but stay fair.\nYou’re not killing ideas, you’re stress-testing them so they can grow stronger.",
                    mascot: "Mascot Black Alert"
                )
            )
        case .feeling:
            return .init(
                title: "Feeling",
                type: .red,
                introduction: SessionIntroduction(
                    title: "Let’s Put Your Feelings\nAbout The Ideas",
                    mascot: "Mascot Red",
                ),
                instruction: SessionInstruction(
                    subtitle:
                        "Share how the idea makes you feel, instinctively, emotionally, intuitively.",
                    body:
                        "There’s no right or wrong here. Go with your gut.  Be honest, not analytical. Sometimes feelings spot what logic misses.",
                    mascot: "Mascot Red Alert"
                )
            )
        }
    }
}
