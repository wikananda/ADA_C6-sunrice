//
//  TimerManager.swift
//  ADA_C6-sunrice
//
//  Created by Antigravity on 24/11/25.
//

import Combine
import Foundation

@MainActor
final class TimerManager {
    private let sessionService: SessionServicing
    private var roundTimer: AnyCancellable?
    private var pollingTask: Task<Void, Never>?
    
    init(sessionService: SessionServicing) {
        self.sessionService = sessionService
    }
    
    // MARK: - Host Timer
    
    func startHostTimer(deadline: Date, onTimeUp: @escaping () async -> Void) {
        cancelAllTimers()
        
        roundTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if Date() >= deadline {
                    self.roundTimer?.cancel()
                    
                    Task {
                        await onTimeUp()
                    }
                }
            }
    }
    
    // MARK: - Guest Timer
    
    func startGuestDeadlineTimer(deadline: Date, onTimeUp: @escaping () async -> Void) {
        cancelAllTimers()
        
        roundTimer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if Date() >= deadline {
                    self.roundTimer?.cancel()
                    
                    Task {
                        await onTimeUp()
                    }
                }
            }
    }
    
    // MARK: - Round Polling (Guest)
    
    func startPollingRound(sessionId: Int64, currentRound: Int64, onRoundChange: @escaping (Int64) async -> Void) {
        cancelPolling()
        
        pollingTask = Task { [weak self] in
            guard let self = self else { return }
            
            var lastKnownRound = currentRound
            
            while !Task.isCancelled {
                do {
                    let updatedSession = try await self.sessionService.fetchSession(id: sessionId)
                    let newRound = updatedSession.current_round ?? 1
                    
                    if newRound != lastKnownRound {
                        lastKnownRound = newRound
                        await onRoundChange(newRound)
                    }
                } catch {
                    print("Error polling round: \(error)")
                }
                
                try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
            }
        }
    }
    
    // MARK: - Deadline Extension
    
    func extendDeadline(by seconds: TimeInterval) -> Date {
        return Date().addingTimeInterval(seconds)
    }
    
    // MARK: - Cleanup
    
    func cancelAllTimers() {
        roundTimer?.cancel()
        roundTimer = nil
        cancelPolling()
    }
    
    // Nonisolated version for deinit
    nonisolated func cancelAllTimersFromDeinit() {
        Task { @MainActor in
            roundTimer?.cancel()
            roundTimer = nil
            cancelPolling()
        }
    }
    
    private func cancelPolling() {
        pollingTask?.cancel()
        pollingTask = nil
    }
    
    deinit {
        cancelAllTimersFromDeinit()
    }
}
