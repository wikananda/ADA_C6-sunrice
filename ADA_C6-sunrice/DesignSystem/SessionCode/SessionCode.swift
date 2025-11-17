//
//  SessionCode.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI
#if canImport(UIKit)
import UIKit
#endif
#if canImport(AppKit)
import AppKit
#endif

struct SessionCode: View {
    var code: String = "000000"
    
    private var formattedCode: String {
        let d = code.prefix(6)
        guard d.count > 3 else { return String(d) }
        return String(d.prefix(3)) + " " + String(d.dropFirst(3))
    }
    
    @State private var showMessage: Bool = false
    
    var body: some View {
        HStack {
            Text("\(formattedCode)")
                .font(.titleMD)
                .foregroundStyle(AppColor.Primary.blue)
            Spacer()
            HStack (spacing: 16) {
                if showMessage {
                    Text("Copied!")
                        .font(.bodySM)
                        .foregroundColor(AppColor.Primary.blue)
                }
                Button(action: {
                    let raw = code.filter { $0.isNumber }
                    #if canImport(UIKit)
                    UIPasteboard.general.string = raw
                    #endif
                    #if canImport(AppKit)
                    let pb = NSPasteboard.general
                    pb.clearContents()
                    pb.setString(raw, forType: .string)
                    #endif
                    withAnimation(.spring(response: 0.15, dampingFraction: 0.9)) {
                        showMessage = true
                    }
                    // Hide after a short delay
                    Task { @MainActor in
                        try? await Task.sleep(nanoseconds: 3_000_000_000) // 3 seconds
                        withAnimation(.easeInOut(duration: 0.15)) { showMessage = false }
                    }
                }) {
                    Image(systemName: "document.on.document")
                        .font(.symbolL)
                        .foregroundStyle(AppColor.Primary.blue)
                }
                Button(action: {}) {
                    Image(systemName: "square.and.arrow.up")
                        .font(.symbolL)
                        .foregroundStyle(AppColor.Primary.blue)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(AppColor.whiteishBlue10)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(
                    AppColor.Primary.blue,
                    lineWidth: 2)
        )
        .contentShape(RoundedRectangle(cornerRadius: 10))
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: showMessage)
    }
}

#Preview {
    SessionCode(code: "000000")
}
