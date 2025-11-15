//
//  Header.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

enum HeaderTrailing {
    case none
    case timer(text: String)
    case skip(action: () -> Void)
}

struct HeaderConfig {
    var title: String?
    var showsBackButton: Bool = true
    var trailing: HeaderTrailing = .none
}

struct Header: View {
    @Environment(\.dismiss) var dismiss
    let config: HeaderConfig
    var onBack: (() -> Void)? = nil
    
    var body: some View {
        HStack {
            // LEFT: back
            if config.showsBackButton {
                BackButton(action: {
                    if let onBack { onBack() } else { dismiss() }
                })
            } else {
                Color.clear
                    .frame(maxWidth: 64, maxHeight: 35)
            }
            
            Spacer()
            
            // CENTER: title
            if let title = config.title {
                Text(config.title ?? "")
                    .bold()
                    .font(.titleSM)
                    .foregroundStyle(AppColor.Primary.gray)
            }
            
            Spacer()
            
            // RIGHT: trailing view (skip or timer)
            trailingView
        }
    }
    
    @ViewBuilder
    private var trailingView: some View {
        switch config.trailing {
        case .none:
            Color.clear
                .frame(maxWidth: 64, maxHeight: 35)
            
        case .skip(let action):
            SkipButton(action: action)
            
        case .timer(let text):
            Timer(text: text)
        }
    }
}

#Preview {
    Header(
        config: .init(
            title: "Header",
            showsBackButton: true,
            trailing: .skip(action: {})
//            trailing: .timer(text: "10:00")
//            trailing: .none
    ))
}

