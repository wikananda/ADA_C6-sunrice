//
//  ParticipantBadge.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 17/11/25.
//

import SwiftUI

struct ParticipantBadge: View {
    let name: String
    var size: CGFloat = 42
    var isHost: Bool = false
    
    private var initial: String {
        String(name.prefix(1))
    }
    
    private var smallSize: CGFloat {
        size * 0.45
    }
    
    private var color: Color {
        isHost ? AppColor.Primary.blue : AppColor.blue40
    }
    
    private var symbol: String {
        isHost ? "crown.fill" : "person.fill"
    }
    
    var body: some View {
        VStack (spacing: 8) {
            ZStack(alignment: .bottomTrailing) {
                Circle()
                    .fill(color)
                    .frame(width: size, height: size)
                    .overlay(
                        Text(initial.uppercased())
                            .font(.symbolL)
                            .foregroundColor(.white)
                    )
                
                Circle()
                    .fill(Color.white)
                    .stroke(color, lineWidth: 2)
                    .frame(width: smallSize, height: smallSize)
                    .overlay(
                        Image(systemName: symbol)
                            .font(.labelTiny)
                            .foregroundColor(color)
                    )
                    .offset(x: size * 0.08, y: size * 0.08)
            }
            Text("\(name)")
                .multilineTextAlignment(.center)
                .font(.labelSM)
                .foregroundColor(AppColor.Primary.gray)
        }
        .frame(width: 64)
        .frame(maxHeight: 64)
        
    }
}

#Preview {
    ParticipantBadge(name: "richard", isHost: false)
}
