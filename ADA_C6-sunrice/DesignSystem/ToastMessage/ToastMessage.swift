//
//  ToastMessage.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct ToastMessage: View {
    var message: String? = "message"
    var body: some View {
        Text("\(message ?? "message")")
    }
}

#Preview {
    ToastMessage()
}
