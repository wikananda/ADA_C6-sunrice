//
//  SessionSetupView.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 18/11/25.
//

import SwiftUI

struct SessionSetupView: View {
    var body: some View {
        VStack {
            Stepper(totalSteps: 3, currentSteps: 1, horizontalPadding: 24)
                .frame(height: 24)
            DefineSessionView()
        }
        .padding()
    }
}

#Preview {
    SessionSetupView()
}
