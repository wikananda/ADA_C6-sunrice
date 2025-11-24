//
//  SessionRoomViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Hanna Nadia Savira on 19/11/25.
//

import Combine
import Foundation
import PostgREST
import Supabase

struct RoomPart {
    let title: String
    let type: MessageCardType
}

enum RoomType {
    case fact, idea, buildon, benefit, risk, feeling

    var shared: RoomPart {
        switch self {
        case .fact:
            return .init(title: "Facts & Info", type: .white)
        case .idea:
            return .init(title: "Idea", type: .green)
        case .buildon:
            return .init(title: "Build On", type: .darkGreen)
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
    let ideaService: IdeaServicing  // Public so CommentSheetView can fetch comments
    private let sessionId: Int64
    
    // UI State
    @Published var inputText: String = ""
    @Published var roomType: SessionRoom = .fact
    @Published var showInstruction: Bool = true
    @Published var deadline: Date = Date()
    @Published var prompt: String = ""
    @Published var messages: [Message] = []  // For backward compatibility, will be deprecated
    @Published var isTimeUp: Bool = false
    @Published var isLoading: Bool = true
    @Published var isUploadingIdeas: Bool = false
    @Published var showRoundSummary: Bool = false
    
    // Local storage (before upload)
    @Published var localIdeas: [LocalIdea] = []
    @Published var localComments: [LocalComment] = []
    
    // Server data (after fetch)
    @Published var serverIdeas: [IdeaDTO] = []
    @Published var commentCounts: [Int64: (yellow: Int, black: Int, darkGreen: Int)] = [:]
    
    // Comment sheet
    @Published var selectedIdeaForComment: IdeaDTO? = nil
    @Published var showCommentSheet: Bool = false

    let isHost: Bool
    
    private var session: SessionDTO?
    private var sequence: SequenceDTO?
    private var roundTimer: AnyCancellable?
    private var pollingTimer: Task<Void, Never>?
    private var currentRound: Int64 = 1
    private var currentTypeId: Int64? = nil
    private var currentUserId: Int64? = nil

    init(id: Int64, isHost: Bool = false, sessionService: SessionServicing, ideaService: IdeaServicing) {
        self.sessionId = id
        self.isHost = isHost
        self.sessionService = sessionService
        self.ideaService = ideaService
        
        Task {
            await loadSessionData()
        }
    }
    
    convenience init(id: Int64, isHost: Bool = false) {
        self.init(
            id: id,
            isHost: isHost,
            sessionService: SessionService(client: supabaseManager),
            ideaService: IdeaService(client: supabaseManager)
        )
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
            
            // Fetch current user ID
            await fetchCurrentUserId()
            
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
    
    private func fetchCurrentUserId() async {
        do {
            struct UserRoleSession: Decodable {
                let user_id: Int64
            }
            
            let response: PostgrestResponse<[UserRoleSession]> = try await supabaseManager
                .from("user_role_sessions")
                .select("user_id")
                .eq("session_id", value: Int(sessionId))
                .limit(1)
                .execute()
            
            if let first = response.value.first {
                currentUserId = first.user_id
                print("Current user ID: \(currentUserId ?? 0)")
            }
        } catch {
            print("Error fetching user ID: \(error)")
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
            print("type: ", type)
            
            // Store current type ID for use in sendMessage
            currentTypeId = typeId
            
            // Map type name to SessionRoom enum
            roomType = mapTypeToSessionRoom(typeName: type.name ?? "")
            
            // Set deadline based on duration_per_round (in minutes, convert to seconds)
             deadline = Date().addingTimeInterval(10)
//            let durationInSeconds = TimeInterval((session?.duration_per_round ?? 1) * 60)
//            deadline = Date().addingTimeInterval(durationInSeconds)
            isTimeUp = false
            showInstruction = true  // Reset instruction for new round
            
            // If guest, start a timer to check deadline
            if !isHost {
                startGuestDeadlineTimer()
            }
            
            // Fetch ideas from previous rounds to display
            if currentRound > 1 {
                // Fetch ALL ideas from ALL previous rounds (cumulative)
                print("📋 Fetching ALL ideas from previous rounds...")
                await fetchIdeasForRound(typeId: nil) // nil = fetch all types for this session
            }
            
        } catch {
            print("Error fetching type: \(error)")
        }
    }
    
    private func mapTypeToSessionRoom(typeName: String) -> SessionRoom {
        switch typeName.lowercased() {
        case "white": return .fact
        case "green": return .idea
        case "darker green": return .buildon
        case "yellow": return .benefit
        case "black": return .risk
        case "red": return .feeling
        default: return .fact
        }
    }
    
    // Helper to get MessageCardType from type_id
    func getMessageCardType(for typeId: Int64?) -> MessageCardType {
        guard let typeId = typeId, let sequence = sequence else { return .white }
        
        switch typeId {
        case sequence.first_round: return .white
        case sequence.second_round: return .green
        case sequence.third_round: return .darkGreen
        case sequence.fourth_round: return .yellow
        case sequence.fifth_round: return .black
        case sequence.sixth_round: return .red
        default: return .white
        }
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
            
            // Upload ideas and show Round Summary
            Task {
                // Upload local ideas to database
                await uploadLocalIdeas()
                
                // Wait a bit for other users to upload their ideas
                try? await Task.sleep(nanoseconds: 2 * 1_000_000_000) // 2 seconds
                
                // Fetch all ideas for current round (including from other users)
                await fetchIdeasForRound(typeId: currentTypeId)
                
                // Show Round Summary screen
                await MainActor.run {
                    showRoundSummary = true
                }
            }
        }
    }
    
    // MARK: - Round Advancement
    func hostAdvanceToNextRound() {
        guard isHost else { return }
        
        Task {
            await advanceToNextRound()
        }
    }
    
    private func advanceToNextRound() async {
        guard let sequence = sequence else { return }
        
        // Hide Round Summary
        showRoundSummary = false
        
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
                            // Round has changed - host advanced
                            currentRound = newRound
                            
                            Task {
                                // Hide round summary if showing
                                await MainActor.run {
                                    showRoundSummary = false
                                }
                                
                                // Load the new round type
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
    
    private func getTypeIdForRound(_ round: Int64) -> Int64? {
        guard let sequence = sequence else { return nil }
        switch round {
        case 1: return sequence.first_round
        case 2: return sequence.second_round
        case 3: return sequence.third_round
        case 4: return sequence.fourth_round
        case 5: return sequence.fifth_round
        case 6: return sequence.sixth_round
        default: return nil
        }
    }
    
    // MARK: - Guest: Deadline Timer
    private func startGuestDeadlineTimer() {
        roundTimer?.cancel()
        roundTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                if Date() >= self.deadline {
                    self.isTimeUp = true
                    self.roundTimer?.cancel()
                    
                    // Guest also needs to upload and show round summary
                    Task {
                        await self.uploadLocalIdeas()
                        
                        // Wait for other users to upload
                        try? await Task.sleep(nanoseconds: 3 * 1_000_000_000) // 3 seconds
                        
                        await self.fetchIdeasForRound(typeId: self.currentTypeId)
                        
                        await MainActor.run {
                            self.showRoundSummary = true
                        }
                    }
                }
            }
    }
    
    func closeInstruction() {
        showInstruction = false
    }

    // MARK: - Message/Idea Input
    func sendMessage() {
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedText.isEmpty, let typeId = currentTypeId else { return }
        
        // Store locally
        let localIdea = LocalIdea(text: trimmedText, typeId: typeId)
        localIdeas.append(localIdea)
        
        // Also add to messages for backward compatibility
        messages.append(Message(text: trimmedText, type: roomType.shared.type))
        
        inputText = ""
    }
    
    // MARK: - Comments
    func openCommentSheet(for idea: IdeaDTO) {
        selectedIdeaForComment = idea
        showCommentSheet = true
    }
    
    func submitComment(text: String, completion: @escaping () -> Void = {}) {
        guard let idea = selectedIdeaForComment,
              let typeId = currentTypeId,
              let userId = currentUserId,
              !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            print("❌ Cannot submit comment: missing data")
            return
        }
        
        // Store comment locally
        let localComment = LocalComment(ideaId: idea.id, text: text, typeId: typeId)
        localComments.append(localComment)
        
        print("💬 Submitting comment for idea \(idea.id) to ideas_comments table...")
        
        // Upload comment immediately
        Task {
            do {
                let params = InsertCommentParams(
                    idea_id: idea.id,
                    text: text,
                    type_id: typeId,
                    user_id: userId
                )
                
                try await ideaService.createComment(params)
                
                // Refresh comment counts
                await fetchCommentCounts()
                
                print("✅ Comment submitted successfully to ideas_comments table")
                
                await MainActor.run {
                    completion()
                }
            } catch {
                print("❌ Error submitting comment: \(error)")
            }
        }
    }
    
    // MARK: - Upload & Fetch Ideas
    private func uploadLocalIdeas() async {
        guard !localIdeas.isEmpty else {
            print("⏭️ No local ideas to upload")
            return
        }
        guard let userId = currentUserId else {
            print("❌ Error: User ID not found for upload")
            return
        }
        
        isUploadingIdeas = true
        defer { isUploadingIdeas = false }
        
        do {
            // Convert local ideas to insert params
            let params = localIdeas.map { idea in
                InsertIdeaParams(
                    text: idea.text,
                    type_id: idea.typeId,
                    session_id: sessionId,
                    user_id: userId
                )
            }
            
            print("📤 Uploading \(params.count) ideas to database...")
            
            // Upload to database
            try await ideaService.createIdeas(params)
            
            // Clear local ideas after successful upload
            localIdeas.removeAll()
            
            print("✅ Successfully uploaded \(params.count) ideas")
        } catch {
            print("❌ Error uploading ideas: \(error)")
        }
    }
    
    private func fetchIdeasForRound(typeId: Int64?) async {
        do {
            // Fetch ideas from database
            serverIdeas = try await ideaService.fetchIdeas(sessionId: sessionId, typeId: typeId)
            
            print("✅ Fetched \(serverIdeas.count) ideas for session \(sessionId), typeId: \(typeId ?? -1)")
            for idea in serverIdeas {
                print("  - Idea \(idea.id): '\(idea.text ?? "")' by user \(idea.user_id ?? -1)")
            }
            
            // If fetching green ideas OR all ideas, also fetch comment counts
            // This ensures we have counts for green ideas even when fetching everything
            if typeId == nil || (typeId == getGreenTypeId()) {
                await fetchCommentCounts()
            }
        } catch {
            print("❌ Error fetching ideas: \(error)")
        }
    }
    
    func fetchCommentCounts() async {
        let ideaIds = serverIdeas.map { $0.id }
        guard !ideaIds.isEmpty else { return }
        
        print("📊 Fetching comment counts for \(ideaIds.count) ideas...")
        
        do {
            let comments = try await ideaService.fetchCommentsForIdeas(ideaIds: ideaIds)
            print("   - Retrieved \(comments.count) total comments from DB")
            
            // Count comments by type for each idea
            var counts: [Int64: (yellow: Int, black: Int, darkGreen: Int)] = [:]
            
            for comment in comments {
                guard let ideaId = comment.idea_id, let typeId = comment.type_id else { continue }
                
                var current = counts[ideaId] ?? (yellow: 0, black: 0, darkGreen: 0)
                
                // Debug log for first few comments to verify type mapping
                if comments.first?.id == comment.id {
                    print("   - Mapping comment type: \(typeId). Yellow: \(isYellowType(typeId)), Black: \(isBlackType(typeId)), DarkGreen: \(isDarkGreenType(typeId))")
                }
                
                if isYellowType(typeId) {
                    current.yellow += 1
                } else if isBlackType(typeId) {
                    current.black += 1
                } else if isDarkGreenType(typeId) {
                    current.darkGreen += 1
                }
                
                counts[ideaId] = current
            }
            
            commentCounts = counts
            print("✅ Updated comment counts for \(counts.count) ideas")
        } catch {
            print("❌ Error fetching comment counts: \(error)")
        }
    }
    
    // MARK: - Helper Methods
    func getGreenTypeId() -> Int64? {
        // Get green type ID from sequence
        // This should match the type ID for green/idea round
        return sequence?.second_round  // Assuming round 2 is green
    }
    
    private func isYellowType(_ typeId: Int64) -> Bool {
        // Check if typeId corresponds to yellow/benefit type
        return sequence?.fourth_round == typeId
    }
    
    private func isBlackType(_ typeId: Int64) -> Bool {
        // Check if typeId corresponds to black/risk type
        return sequence?.fifth_round == typeId
    }
    
    private func isDarkGreenType(_ typeId: Int64) -> Bool {
        // Check if typeId corresponds to darker green/buildon type
        return sequence?.third_round == typeId
    }
    
    var isCommentRound: Bool {
        // Comment rounds are darker green, yellow, and black (rounds 3, 4, 5)
        guard let typeId = currentTypeId else { return false }
        return isDarkGreenType(typeId) || isYellowType(typeId) || isBlackType(typeId)
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
