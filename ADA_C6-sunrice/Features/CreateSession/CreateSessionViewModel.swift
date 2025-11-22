//
//  CreateSessionViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 19/11/25.
//

import SwiftUI
import Combine

enum CreateSessionStep: Int, CaseIterable {
    case enterName = 1
    case defineSession
    case selectPreset
    case reviewSession
    case lobby
    
    var title: String {
        if self == .lobby {
            return "Session Lobby"
        } else {
            return "Session Setup"
        }
    }
}

@MainActor
final class CreateSessionViewModel: ObservableObject {
    private let userService: UserServicing
    private let userRoleService: UserRoleServicing
    private let sessionService: SessionServicing
    private let hostRoleId: Int64 = 1
    
    var currentTitle: String { step.title }
    
    // MARK: Enter Name
    let nameVM = EnterNameViewModel()
    @Published private(set) var currentUser: UserDTO?
    @Published private(set) var currentUserRole: UserRoleDTO?
    @Published private(set) var newSession: SessionDTO?
    @Published private(set) var lobbySession: SessionDTO?
    @Published private(set) var lobbyMode: ModeDTO?
    @Published var lobbyParticipants: [UserDTO] = []
    @Published var isPerformingAction = false
    @Published var errorMessage: String?
    @Published var isLoadingPresets = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(
        userService: UserServicing,
        userRoleService: UserRoleServicing,
        sessionService: SessionServicing
    ) {
        self.userService = userService
        self.userRoleService = userRoleService
        self.sessionService = sessionService
        // Forward changes from child VM to parent's view
        nameVM.objectWillChange
            .sink{ [weak self] _ in self?.objectWillChange.send() }
            .store(in: &cancellables)
        
        Task { await loadPresets() }
    }
    
    @MainActor
    convenience init() {
        self.init(
            userService: UserService(client: supabaseManager),
            userRoleService: UserRoleService(client: supabaseManager),
            sessionService: SessionService(client: supabaseManager)
        )
    }
    
    @Published var step: CreateSessionStep = .enterName
    
    // MARK: Define Session
    @Published var topic: String = ""
    @Published var description: String = ""
    
    // MARK: Select Presets
    @Published var selectedPreset: SessionPreset? = nil
    @Published var presets: [SessionPreset] = []
    let tbaPresets: [TBASessionPreset] = [
        TBASessionPreset(id: 1, title: "Identifying Solutions"),
        TBASessionPreset(id: 2, title: "Strategic Planning")
    ]
    
    // MARK: Review Session
    @Published var durationPerRound: Int = 5
    
    // MARK: Button Behavior
    var buttonText: String {
        switch step {
        case .enterName:
            return "Continue"
        case .defineSession:
            return "Next — Choose a Flow"
        case .selectPreset:
            return "Next — Review Session"
        case .reviewSession:
            return "Go to Lobby"
        case .lobby:
            return "Start Session"
        }
    }
    
    var isNextButtonDisabled: Bool {
        switch step {
        case .enterName:
            return !nameVM.isValid || isPerformingAction
        case .defineSession:
            return topic.isEmpty
        case .selectPreset:
            return selectedPreset == nil || isLoadingPresets
        case .reviewSession, .lobby:
            return false
        }
    }
    
    // MARK: Functions
    func handleBack(dismiss: () -> Void) {
        guard let previous = CreateSessionStep(rawValue: step.rawValue - 1) else {
            dismiss()
            return
        }
        withAnimation { step = previous }
    }
    
    func handleNext() {
        Task { await handleNextAction() }
    }
    
    private func handleNextAction() async {
        switch step {
        case .enterName:
            await persistName()
        case .reviewSession:
            await createSession()
        default:
            advanceToNextStep()
        }
    }
    
    private func advanceToNextStep() {
        guard let next = CreateSessionStep(rawValue: step.rawValue + 1) else { return }
        withAnimation { step = next }
    }
    
    
    
    // MARK: Services
    private func persistName() async {
        guard nameVM.isValid, !isPerformingAction else { return }
        isPerformingAction = true
        defer { isPerformingAction = false }
        
        do {
            errorMessage = nil
            let role = try await prepareUserRole()
            let user = try await userService.createUser(name: nameVM.username)
            currentUser = user
            currentUserRole = try await userRoleService.attach(userId: user.id, toRole: role.id)
            print("currentUserRole: ", currentUserRole)
            advanceToNextStep()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // Prepare user role
    private func prepareUserRole() async throws -> UserRoleDTO {
        if let role = currentUserRole {
            return role
        }
        let created = try await userRoleService.createUserRole(roleId: hostRoleId)
        currentUserRole = created
        return created
    }
    
    func makeParticipants() -> [UserDTO] {
        var baseNames = ["Saskia", "Selena", "Hendy", "Richard"]
        if !nameVM.username.isEmpty {
            baseNames.insert(nameVM.username, at: 0)
        }
        return baseNames.enumerated().map { idx, name in
            UserDTO(id: Int64(idx + 1), name: name, status: 1, created_at: nil)
        }
    }
    
    func createSession() async {
        guard !isPerformingAction else { return }
        guard let selectedPreset else {
            errorMessage = "Select a preset first."
            return
        }
        isPerformingAction = true
        defer { isPerformingAction = false }
        
        do {
            errorMessage = nil
            let session = try await sessionService.createSession(
                topic: topic,
                description: description,
                duration_per_round: String(durationPerRound),
                mode_id: selectedPreset.id
            )
            newSession = session
            lobbyParticipants = makeParticipants()
            await fetchSessionAndMode(sessionId: session.id)
            advanceToNextStep()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    // MARK: Preset & lobby helpers
    private func loadPresets() async {
        isLoadingPresets = true
        defer { isLoadingPresets = false }
        do {
            let modes = try await sessionService.fetchModes()
            let mapped = modes.compactMap { mode in
                SessionPreset(
                    id: mode.id,
                    title: mode.title ?? mode.name ?? "Preset \(mode.id)",
                    description: mode.description ?? "Description coming soon",
                    duration: mode.duration ?? "\(mode.num_of_rounds ?? mode.round_count ?? 0) rounds",
                    numOfRounds: Int(mode.num_of_rounds ?? mode.round_count ?? 0),
                    sequence: mode.sequence ?? [],
                    overview: mode.overview ?? "Overview coming soon",
                    bestFor: mode.best_for ?? [],
                    outcome: mode.outcome ?? ""
                )
            }
            presets = mapped
            if selectedPreset == nil, let first = mapped.first {
                selectedPreset = first
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private func fetchSessionAndMode(sessionId: Int64) async {
        do {
            let session = try await sessionService.fetchSession(id: sessionId)
            lobbySession = session
            if let modeId = session.mode_id {
                lobbyMode = try await sessionService.fetchMode(id: modeId)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
