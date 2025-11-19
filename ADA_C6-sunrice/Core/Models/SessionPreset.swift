//
//  SessionPreset.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 19/11/25.
//
import Foundation

struct SessionPreset: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let description: String
    let duration: String
    let numOfRounds: Int
    let sequence: [String]
    let overview: String
    let bestFor: [String]
    let outcome: String
}
