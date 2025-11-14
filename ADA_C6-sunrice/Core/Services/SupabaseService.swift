//
//  SupabaseService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 03/11/25.
//

import Supabase
import Foundation

let dbClient = SupabaseClient(supabaseURL: URL(string: "https://whghhtqtgqgxsqoejbsd.supabase.co")!, supabaseKey: "sb_publishable_ucXVh30ZCqU4QVedXgK_Kg_6nFjySek")

func insertIdea(_ idea: Idea) async throws {
    try await dbClient
        .from("ideas")
        .insert(idea)
        .execute()
    print("Selena sends idea: ", idea)
}
