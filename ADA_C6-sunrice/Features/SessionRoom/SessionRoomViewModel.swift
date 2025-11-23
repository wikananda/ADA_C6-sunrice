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

@MainActor
final class SessionRoomViewModel: ObservableObject {
    private let sessionService: SessionServicing
    private let sessionId: Int64
    
    @Published var inputText: String = ""
    @Published var roomType: SessionRoom = .fact
    @Published var showInstruction: Bool = true
    @Published var deadline: Date = Date()
    @Published var prompt: String = ""
    @Published var messages: [Message] = []
    @Published var isTimeUp: Bool = false
    @Published var isLoading: Bool = true

    let isHost: Bool
    
    private var session: SessionDTO?
    private var sequence: SequenceDTO?
    private var roundTimer: AnyCancellable?
    private var pollingTimer: Task<Void, Never>?
    private var currentRound: Int64 = 1

    init(id: Int64, isHost: Bool = false, sessionService: SessionServicing) {
        self.sessionId = id
        self.isHost = isHost
        self.sessionService = sessionService
        
        Task {
            await loadSessionData()
        }
    }
    
    convenience init(id: Int64, isHost: Bool = false) {
        self.init(id: id, isHost: isHost, sessionService: SessionService(client: supabaseManager))
    }
    
    private func loadSessionData() async {
        do {
            // Fetch session
            session = try await sessionService.fetchSession(id: sessionId)
            
            guard let session = session, let modeId = session.mode_id else {
                print("Error: Session or mode_id not found")
                return
            }
            
            // Fetch sequence
            sequence = try await sessionService.fetchSequence(modeId: modeId)
            
            // Set prompt
            prompt = session.topic ?? "Session Topic"
            
            // Get current round
            currentRound = session.current_round ?? 1
            
            // Load current round type
            await loadRoundType(round: currentRound)
            
            // Start timer or polling based on role
            if isHost {
                startRoundTimer()
            } else {
                startPollingRound()
            }
            
            isLoading = false
        } catch {
            print("Error loading session data: \(error)")
        }
    }
    
    private func loadRoundType(round: Int64) async {
        guard let sequence = sequence else { return }
        
        // Get type ID for current round
        let typeId: Int64? = {
            switch round {
            case 1: return sequence.first_round
            case 2: return sequence.second_round
            case 3: return sequence.third_round
            case 4: return sequence.fourth_round
            case 5: return sequence.fifth_round
            case 6: return sequence.sixth_round
            default: return nil
            }
        }()
        
        guard let typeId = typeId else {
            print("No type found for round \(round)")
            return
        }
        
        do {
            // Fetch type from database
            let type = try await sessionService.fetchType(id: typeId)
            
            // Map type name to SessionRoom enum
            roomType = mapTypeToSessionRoom(typeName: type.name ?? "")
            
            // Set deadline (5 seconds for testing)
            deadline = Date().addingTimeInterval(5)
            isTimeUp = false
            
        } catch {
            print("Error fetching type: \(error)")
        }
    }
    
    private func mapTypeToSessionRoom(typeName: String) -> SessionRoom {
        let lowercased = typeName.lowercased()
        if lowercased.contains("white") || lowercased.contains("fact") {
            return .fact
        } else if lowercased.contains("green") || lowercased.contains("idea") {
            return .idea
        } else if lowercased.contains("yellow") || lowercased.contains("benefit") {
            return .benefit
        } else if lowercased.contains("black") || lowercased.contains("risk") {
            return .risk
        } else if lowercased.contains("red") || lowercased.contains("feeling") {
            return .feeling
        }
        return .fact // default
    }
    
    // MARK: - Host: Round Timer
    private func startRoundTimer() {
        roundTimer?.cancel()
        roundTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.checkTimeStatus()
            }
    }
    
    private func checkTimeStatus() {
        if Date() >= deadline {
            isTimeUp = true
            roundTimer?.cancel()
            
            // Move to next round after a delay
            Task {
                try? await Task.sleep(nanoseconds: 5 * 1_000_000_000) // 2 seconds delay
                await advanceToNextRound()
            }
        }
    }
    
    private func advanceToNextRound() async {
        guard let sequence = sequence else { return }
        
        let nextRound = currentRound + 1
        
        // Check if there are more rounds
        let hasNextRound: Bool = {
            switch nextRound {
            case 1: return sequence.first_round != nil
            case 2: return sequence.second_round != nil
            case 3: return sequence.third_round != nil
            case 4: return sequence.fourth_round != nil
            case 5: return sequence.fifth_round != nil
            case 6: return sequence.sixth_round != nil
            default: return false
            }
        }()
        
        if hasNextRound {
            currentRound = nextRound
            
            // Update current_round in database
            do {
                try await sessionService.updateCurrentRound(sessionId: sessionId, round: currentRound)
                await loadRoundType(round: currentRound)
                startRoundTimer()
            } catch {
                print("Error updating round: \(error)")
            }
        } else {
            print("Session complete!")
            // TODO: Navigate to session summary or end screen
        }
    }
    
    // MARK: - Guest: Poll for round changes
    private func startPollingRound() {
        pollingTimer?.cancel()
        pollingTimer = Task {
            while !Task.isCancelled {
                do {
                    let updatedSession = try await sessionService.fetchSession(id: sessionId)
                    let newRound = updatedSession.current_round ?? 1
                    
                    await MainActor.run {
                        if newRound != currentRound {
                            currentRound = newRound
                            Task {
                                await loadRoundType(round: currentRound)
                            }
                        }
                    }
                } catch {
                    print("Error polling round: \(error)")
                }
                
                try? await Task.sleep(nanoseconds: 1 * 500_000_000) // 0.5 second
            }
        }
    }
    
    func closeInstruction() {
        showInstruction = false
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
    
    deinit {
        roundTimer?.cancel()
        pollingTimer?.cancel()
    }
}
