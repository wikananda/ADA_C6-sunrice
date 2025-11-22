//
//  SupabaseService.swift
//  ADA_C6-sunrice
//
//  Created by Komang Wikananda on 03/11/25.
//

import Supabase
import Foundation

// main db
//let supabaseManager = SupabaseClient(supabaseURL: URL(string: "https://rztbwfwsdfgmnrsllwav.supabase.co")!, supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ6dGJ3ZndzZGZnbW5yc2xsd2F2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjIzMzEwMTQsImV4cCI6MjA3NzkwNzAxNH0.PGzj82THrxmzlkkbeAvkzUjteRyTCMFewosVIadpKuQ")

// test db
let supabaseManager = SupabaseClient(supabaseURL: URL(string: "https://whghhtqtgqgxsqoejbsd.supabase.co")!, supabaseKey: "sb_publishable_ucXVh30ZCqU4QVedXgK_Kg_6nFjySek")



func insertIdea(_ idea: Idea) async throws {
    try await supabaseManager
        .from("ideas")
        .insert(idea)
        .execute()
    print("Selena sends idea: ", idea)
}
