//
//  JoinByCodeViewModel.swift
//  ADA_C6-sunrice
//
//  Created by Codex on 15/11/25.
//

import SwiftUI
import Combine

@MainActor
final class EnterCodeViewModel: ObservableObject {
    
    @Published var sessionCode: String = "" // The raw digit
    @Published var displayCode: String = "" // for display purpose

    var isValidCode: Bool { sessionCode.count == 6 }

    var formattedCode: String {
        let d = sessionCode.prefix(6)
        guard d.count > 3 else { return String(d) }
        return String(d.prefix(3)) + " " + String(d.dropFirst(3))
    }

    // Call onChange in textfield to put the change in displayCode to sessionCode
    func handleDisplayChange(_ newValue: String) {
        let digits = newValue.filter { $0.isNumber }
        let clamped = String(digits.prefix(6))

        if sessionCode != clamped {
            sessionCode = clamped
        }

        let formatted = format(clamped)
        if displayCode != formatted {
            displayCode = formatted
        }
    }

    private func format(_ digits: String) -> String {
        let d = digits.prefix(6)
        guard d.count > 3 else { return String(d) }
        return String(d.prefix(3)) + " " + String(d.dropFirst(3))
    }
}

