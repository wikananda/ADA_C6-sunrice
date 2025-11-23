//
//  SessionRoomViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Hanna Nadia Savira on 19/11/25.
//

import Combine
import Foundation

struct RoomPart {
    let title: String
    let type: MessageCardType
}

enum RoomType {
    case fact, idea, benefit, risk, feeling

    var shared: RoomPart {
        switch self {
        case .fact:
            return .init(title: "Facts & Info", type: .white)
        case .idea:
            return .init(title: "Idea", type: .green)
        case .benefit:
            return .init(title: "Benefits", type: .yellow)
        case .risk:
            return .init(title: "Risks", type: .black)
        case .feeling:
            return .init(title: "Feeling", type: .red)
        }
    }
}

struct Message {
    let text: String
    let type: MessageCardType
}

final class SessionRoomViewModel: ObservableObject {
    @Published var inputText: String = ""

    @Published var roomType: SessionRoom
    @Published var showInstruction: Bool = true
    @Published var deadline: Date
    @Published var prompt: String
    @Published var messages: [Message]
    @Published var isTimeUp: Bool = false

    let isHost: Bool

    private var timer: AnyCancellable?

    init(id: Int64) {
        // TODO: 1. Fetch data from Supabase

        // TODO: 2. Initialize needed data, replace the dummy data below
        deadline = Date().addingTimeInterval(5 * 60)
        prompt = "How might we make onboarding more delightful?"
        isHost = true
        roomType = .fact

        messages = [
//            Message(
//                text: "Many new users feel unsure about what to do after opening an app for the first time.",
//                type: .white
//            ),
//            Message(
//                text: "The ideal onboarding duration for most users is 1–2 minutes across 3–5 clear steps.",
//                type: .white
//            ),
//            Message(
//                text: "Users understand information better when onboarding includes simple visuals or supporting illustrations.",
//                type: .white
//            ),
//            Message(
//                text: "Mobile users tend to skip onboarding screens that contain long paragraphs of text.",
//                type: .white
//            ),
        ]
    }
    
    func closeInstruction() {
        showInstruction = false
    }

    func startTimer() {
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkTimeStatus()
            }
    }

    func checkTimeStatus() {
        if Date() >= deadline {
            isTimeUp = true
            timer?.cancel()
        }
    }

    func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(
            in: .whitespacesAndNewlines
        )
        if !trimmedText.isEmpty {
            messages.append(Message(text: trimmedText, type: roomType.shared.type))
            inputText = ""
        }

        // TODO: upload message to Supabase
        //        Task {
        //            let newIdea = Idea(
        //                id: nil,
        //                text: trimmedText,
        //                type: nil,
        //                session_id: nil  // belum menerima nilai id session asli, jd masih nil
        //            )
        //            do {
        //                try await insertIdea(newIdea)
        //            } catch {
        //                print("Error inserting idea: \(error)")
        //            }
        //        }
    }

    func onTapExtensionButton() {
        if isHost {
            deadline.addTimeInterval(30)
        } else {
            // TODO: send request time extension to the host
        }
    }
}
