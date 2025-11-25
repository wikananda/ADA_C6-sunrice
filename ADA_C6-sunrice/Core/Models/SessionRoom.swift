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
    let heading: String
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
                    mascot: "white_clarity_animation"
                ),
                instruction: SessionInstruction(
                    heading:
                        "Round 1:\nCLARITY",
                    subtitle:
                        "See things as they are.",
                    body:
                        "Before ideas begin to grow, let’s ground ourselves in what’s true.\nShare any facts, context, or observations that can help us see the topic clearly — without opinions or assumptions.",
                    mascot: "white_clarity_animation"
                )
            )
        case .idea:
            return .init(
                title: "Idea",
                type: .green,
                introduction: SessionIntroduction(
                    title: "Let’s Generate\nSome Ideas!",
                    mascot: "green_bloom_animation",
                ),
                instruction: SessionInstruction(
                    heading:
                        "Round 2:\nBLOOM I",
                    subtitle:
                        "Grow the idea",
                    body:
                        "With our foundation set, it’s time to explore possibilities.\nAdd any ideas that come to mind — simple, bold, or unfinished. Let them branch out freely.",
                    mascot: "green_bloom_animation"
                )
            )
        case .buildon:
            return .init(
                title: "Build On the Ideas",
                type: .darkGreen,
                introduction: SessionIntroduction(
                    title: "Let’s Buil Upon \nThese Ideas!",
                    mascot: "green_bloom_animation",
                ),
                instruction: SessionInstruction(
                    heading:
                        "Round 3:\nBLOOM II",
                    subtitle:
                        "Expand what stands out",
                    body:
                        "Choose an idea from the previous round and build on it.\nAdd detail, depth, or a new angle — anything that helps the idea take a more defined shape.",
                    mascot: "green_bloom_animation"
                )
            )
        case .benefit:
            return .init(
                title: "Benefits",
                type: .yellow,
                introduction: SessionIntroduction(
                    title: "Let’s Seek The\nBenefits of The Ideas",
                    mascot: "yellow_ray_animation",
                ),
                instruction: SessionInstruction(
                    heading:
                        "Round 4:\nRAY",
                    subtitle:
                        "Spot the bright side",
                    body:
                        "Look at one idea and highlight what makes it promising.\nShare the strengths, opportunities, or potential you see — what could make this idea worthwhile?",
                    mascot: "yellow_ray_animation"
                )
            )
        case .risk:
            return .init(
                title: "Risks",
                type: .black,
                introduction: SessionIntroduction(
                    title: "Let’s Analyze The\nRisks of The Ideas",
                    mascot: "black_frame_animation",
                ),
                instruction: SessionInstruction(
                    heading:
                        "Round 5:\nFRAME",
                    subtitle:
                        "Challenge the edges",
                    body:
                        "Now let’s look at the idea with a grounded, realistic lens. What might limit it? What could be difficult or uncertain?\nYour insights help refine the idea, not diminish it.",
                    mascot: "black_frame_animation"
                )
            )
        case .feeling:
            return .init(
                title: "Feeling",
                type: .red,
                introduction: SessionIntroduction(
                    title: "Let’s Put Your Feelings\nAbout The Ideas",
                    mascot: "red_pulse_animation",
                ),
                instruction: SessionInstruction(
                    heading:
                        "Round 6:\nPULSE",
                    subtitle:
                        "Feel what matters",
                    body:
                        "After seeing the idea from all angles, tune into your instinct. How does it make you feel — hopeful, hesitant, curious?\nThere’s no right answer. Let your honest reaction guide your response.",
                    mascot: "red_pulse_animation"
                )
            )
        }
    }
}
