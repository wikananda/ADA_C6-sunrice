//
//  OnboardingViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Codex on 14/11/25.
//

import SwiftUI
import Combine

@MainActor
final class OnboardingViewModel: ObservableObject {
    @Published var page: Int = 0
    let totalPages: Int
    @Published var didFinish: Bool = false
    
    init(totalPages: Int) {
        self.totalPages = max(totalPages, 1)
    }
    
    var canGoBack: Bool { page > 0 }
    var isLastPage: Bool { page >= totalPages - 1 }
    var primaryButtonTitle: String { isLastPage ? "LET'S BEGIN" : "CONTINUE" }
    
    func next() {
        if isLastPage {
            didFinish = true
        } else {
            page += 1
        }
    }
    
    func back() {
        page = max(page - 1, 0)
    }
    
    func skipToEnd() {
        didFinish = true
    }
}

