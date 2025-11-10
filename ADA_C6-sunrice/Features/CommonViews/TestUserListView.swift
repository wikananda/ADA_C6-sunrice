//
//  TestFetchDataView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 09/11/25.
//
import SwiftUI
import Foundation

struct TestUserListView: View {
    @State private var users: [Users] = []
    @State private var isLoading = false

    var body: some View {
        NavigationView {
            Group {
                if isLoading {
                    ProgressView("Loading users...")
                } else {
                    List(users) { user in
                        VStack(alignment: .leading) {
                            Text(user.username)
                                .font(.headline)
                            Text("Status: \(user.status)")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
            .navigationTitle("Users")
            .task {
                await fetchUsers()
                print("🚀 Fetching users...")
            }
        }
    }

    func fetchUsers() async {
        isLoading = true
            do {
                let response = try await supabaseManager
                    .from("users")
                    .select()
                    .execute()
                
                let data = response

                print("🔹 Raw data: \(data)")

                let decoder = JSONDecoder()
                let decoded = try decoder.decode([Users].self, from: response.data)
                print("✅ Decoded:", decoded)

                users = decoded
            } catch {
                print("❌ Error:", error)
            }
            isLoading = false
    }
}
