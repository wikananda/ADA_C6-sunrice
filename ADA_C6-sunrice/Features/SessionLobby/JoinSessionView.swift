//
//  JoinSessionView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 15/11/25.
//

import SwiftUI

struct JoinSessionView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            // Header
            Header(config: .init(
                title: "Join a Session"
            ))
            
            Spacer(minLength: 24)
            
//            EnterSessionCodeView()
            EnterNameView()
        }
        .padding(.horizontal)
    }
}

#Preview {
    JoinSessionView()
}
