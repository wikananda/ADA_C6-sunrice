//
//  SessionRoomViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Hanna Nadia Savira on 19/11/25.
//  Refactored by Antigravity on 24/11/25.
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
    // MARK: - Dependencies
    private let sessionService: SessionServicing
    let ideaService: IdeaServicing  // Public for CommentSheetView
    private let summaryService: SummaryServicing
    
    // Managers
    private let roundManager: RoundManager
    private let timerManager: TimerManager
    private let ideaManager: IdeaManager
    private let summaryManager: SummaryManager
    
    private let sessionId: Int64
    let isHost: Bool
    
    // MARK: - UI State
    @Published var inputText: String = ""
    @Published var roomType: SessionRoom = .fact
    @Published var showInstruction: Bool = true
    @Published var deadline: Date = Date()
    @Published var prompt: String = ""
    @Published var messages: [Message] = []  // For backward compatibility
    @Published var isTimeUp: Bool = false
    @Published var isLoading: Bool = true
    @Published var showRoundSummary: Bool = false
    @Published var shouldExitToHome: Bool = false
    @Published var isSessionFinished: Bool = false
    
    // Comment sheet
    @Published var selectedIdeaForComment: IdeaDTO? = nil
    @Published var showCommentSheet: Bool = false
    
    // MARK: - Delegated State (from IdeaManager)
    var localIdeas: [LocalIdea] { ideaManager.localIdeas }
    var serverIdeas: [IdeaDTO] { ideaManager.serverIdeas }
    var serverComments: [IdeaCommentDTO] { ideaManager.serverComments }
    var commentCounts: [Int64: CommentCounts] { ideaManager.commentCounts }
    var isUploadingIdeas: Bool { ideaManager.isUploadingIdeas }
    
    // MARK: - Delegated State (from SummaryManager)
    var summary: IdeaSummary? { summaryManager.summary }
    var isLoadingSummary: Bool { summaryManager.isLoadingSummary }
    var summaryError: String? { summaryManager.summaryError }
    
    // MARK: - Session State
    private var session: SessionDTO?
    private var sequence: SequenceDTO?
    private var currentRound: Int64 = 1
    var currentTypeId: Int64? = nil
    private var currentUserId: Int64? = nil

    // MARK: - Initialization
    
    init(id: Int64, isHost: Bool = false, sessionService: SessionServicing, ideaService: IdeaServicing, summaryService: SummaryServicing) {
        self.sessionId = id
        self.isHost = isHost
        self.sessionService = sessionService
        self.ideaService = ideaService
        self.summaryService = summaryService
        
        // Initialize managers
        self.roundManager = RoundManager(sessionService: sessionService)
        self.timerManager = TimerManager(sessionService: sessionService)
        self.ideaManager = IdeaManager(ideaService: ideaService)
        self.summaryManager = SummaryManager(summaryService: summaryService)
        
        // Setup bindings to propagate manager changes
        setupManagerBindings()
        
        Task {
            await loadSessionData()
        }
    }
    
    // Convenience initializer for default services
    convenience init(id: Int64, isHost: Bool = false) {
        self.init(
            id: id,
            isHost: isHost,
            sessionService: SessionService(client: supabaseManager),
            ideaService: IdeaService(client: supabaseManager),
            summaryService: SummaryService(client: supabaseManager)
        )
    }
    
    private func setupManagerBindings() {
        // Propagate IdeaManager changes to trigger view updates
        ideaManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
        
        // Propagate SummaryManager changes to trigger view updates
        summaryManager.objectWillChange.sink { [weak self] _ in
            self?.objectWillChange.send()
        }.store(in: &cancellables)
    }
    
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Session Loading
    
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
            
            guard let sequence = sequence else {
                print("Error: Sequence not found")
                return
            }
            
            // Configure RoundManager with sequence
            roundManager.setSequence(sequence)
            
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
                startHostTimer()
            } else {
                startGuestPolling()
            }
            
            // Start polling for comment counts
            timerManager.startPollingCommentCounts { [weak self] in
                await self?.fetchCommentCounts()
            }
            
            isLoading = false
        } catch {
            print("Error loading session data: \(error)")
        }
    }
    
    // MARK: - Cleanup
    
    func cleanup() {
        print("🧹 Cleaning up session resources...")
        
        // Cancel timer if running
        timerManager.cancelAllTimers()
        
        // Clear all data
        ideaManager.clearLocalIdeas()
        summaryManager.clearSummary()
        
        print("✅ Session cleanup complete")
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
    
    // MARK: - Round Management
    
    private func loadRoundType(round: Int64) async {
        guard let session = session else { return }
        
        do {
            let roundInfo = try await roundManager.loadRoundType(round: round, session: session)
            
            // Update state
            currentTypeId = roundInfo.typeId
            roomType = roundInfo.sessionRoom
            deadline = roundInfo.deadline
            isTimeUp = false
            showInstruction = true
            
            // Fetch ideas from previous rounds (cumulative)
            if currentRound > 1 {
                print("📋 Fetching ALL ideas from previous rounds...")
                try await ideaManager.fetchIdeas(sessionId: sessionId, typeId: nil)
            }
        } catch {
            print("Error loading round type: \(error)")
        }
    }
    
    // MARK: - Timer Management
    
    private func startHostTimer() {
        timerManager.startHostTimer(deadline: deadline) { [weak self] in
            await self?.handleTimeUp()
        }
    }
    
    private func startGuestPolling() {
        // Start deadline timer
        timerManager.startGuestDeadlineTimer(deadline: deadline) { [weak self] in
            await self?.handleTimeUp()
        }
        
        // Start polling for round changes
        timerManager.startPollingRound(sessionId: sessionId, currentRound: currentRound) { [weak self] newRound in
            await self?.handleRoundChange(newRound: newRound)
        }
    }
    
    private func handleTimeUp() async {
        isTimeUp = true
        
        // Upload local ideas to database
        await uploadLocalIdeas()
        
        // Wait for other users to upload
        let waitTime = isHost ? 2 : 3
        try? await Task.sleep(nanoseconds: UInt64(waitTime) * 1_000_000_000)
        
        // Fetch ideas for review screen
        // In comment rounds, fetch green ideas (that have comments)
        // In other rounds, fetch ideas for current round
        let typeIdToFetch = isCommentRound ? roundManager.getGreenTypeId() : currentTypeId
        try? await ideaManager.fetchIdeas(sessionId: sessionId, typeId: typeIdToFetch)
        
        // Show Round Summary screen
        showRoundSummary = true
    }
    
    private func handleRoundChange(newRound: Int64) async {
        currentRound = newRound
        showRoundSummary = false
        await loadRoundType(round: currentRound)
        
        // Restart guest timers with new deadline and round
        if !isHost {
            startGuestPolling()
        }
    }
    
    // MARK: - Round Advancement (Host)
    
    func hostAdvanceToNextRound() {
        guard isHost else { return }
        
        Task {
            await advanceToNextRound()
        }
    }
    
    private func advanceToNextRound() async {
        showRoundSummary = false
        isTimeUp = false
        
        let nextRound = currentRound + 1
        
        if roundManager.hasNextRound(after: currentRound) {
            currentRound = nextRound
            
            // Update current_round in database
            do {
                try await sessionService.updateCurrentRound(sessionId: sessionId, round: currentRound)
                await loadRoundType(round: currentRound)
                startHostTimer()
            } catch {
                print("Error updating round: \(error)")
            }
        } else {
            print("Session complete!")
            isSessionFinished = true
        }
    }
    
    // MARK: - Message/Idea Input
    
    func sendMessage() {
        guard let typeId = currentTypeId else { return }
        
        ideaManager.addLocalIdea(text: inputText, typeId: typeId)
        
        // Also add to messages for backward compatibility
        let trimmedText = inputText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedText.isEmpty {
            messages.append(Message(text: trimmedText, type: roomType.shared.type))
        }
        
        inputText = ""
    }
    
    private func uploadLocalIdeas() async {
        guard let userId = currentUserId else {
            print("❌ Error: User ID not found for upload")
            return
        }
        
        do {
            try await ideaManager.uploadLocalIdeas(sessionId: sessionId, userId: userId)
        } catch {
            print("❌ Error uploading ideas: \(error)")
        }
    }
    
    // MARK: - Comments
    
    func openCommentSheet(for idea: IdeaDTO) {
        selectedIdeaForComment = idea
        showCommentSheet = true
    }
    
    func submitComment(text: String, completion: @escaping () -> Void = {}) {
        guard let idea = selectedIdeaForComment,
              let typeId = currentTypeId,
              let userId = currentUserId else {
            print("❌ Cannot submit comment: missing data")
            return
        }
        
        Task {
            do {
                try await ideaManager.submitComment(
                    ideaId: idea.id,
                    text: text,
                    typeId: typeId,
                    userId: userId
                )
                
                // Refresh comment counts
               try await ideaManager.fetchCommentCounts(roundManager: roundManager)
                
                await MainActor.run {
                    completion()
                }
            } catch {
                print("❌ Error submitting comment: \(error)")
            }
        }
    }
    
    func fetchCommentCounts() async {
        do {
            try await ideaManager.fetchCommentCounts(roundManager: roundManager)
        } catch {
            print("❌ Error fetching comment counts: \(error)")
        }
    }
    
    func fetchAllComments() async {
        do {
            try await ideaManager.fetchComments(roundManager: roundManager)
        } catch {
            print("❌ Error fetching comments: \(error)")
        }
    }
    
    func fetchSummary() async {
        guard let typeId = currentTypeId else {
            print("⏭️ No typeId available for summary")
            return
        }
        
        guard let roundType = getCurrentRoundType(typeId: typeId) else {
            print("⏭️ No summary available for this round type")
            return
        }
        
        await summaryManager.fetchSummary(sessionId: Int(sessionId), roundType: roundType, isHost: isHost)
    }
    
    // MARK: - Helper Methods
    
    func getGreenTypeId() -> Int64? {
        return roundManager.getGreenTypeId()
    }
    
    func getMessageCardType(for typeId: Int64?) -> MessageCardType {
        return roundManager.getMessageCardType(for: typeId)
    }
    
    var isCommentRound: Bool {
        return roundManager.isCommentRound(typeId: currentTypeId)
    }
    
    private func getCurrentRoundType(typeId: Int64) -> RoundType? {
        guard let sequence = sequence else { return nil }
        
        switch typeId {
        case sequence.first_round: return .white
        case sequence.second_round: return .green
        case sequence.fourth_round: return .yellow
        case sequence.fifth_round: return .black
        case sequence.sixth_round: return .red
        default: return nil  // Return nil for darkGreen and unknown types
        }
    }
    
    func closeInstruction() {
        showInstruction = false
    }
    
    func onTapExtensionButton() {
        if isHost {
            deadline.addTimeInterval(30)
        } else {
            // TODO: send request time extension to the host
        }
    }
    
    // MARK: - Cleanup
    
    deinit {
        timerManager.cancelAllTimersFromDeinit()
    }
}
