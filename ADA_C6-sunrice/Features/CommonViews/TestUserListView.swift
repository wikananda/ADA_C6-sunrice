////
////  TestFetchDataView.swift
////  ADA_C6-sunrice
////
////  Created by Selena Aura on 09/11/25.
////
//import SwiftUI
//import Foundation
//
//struct TestUserListView: View {
//    @State private var users: [User] = []
//    @State private var isLoading = false
//    
//    var body: some View {
//        NavigationView {
//            List(users) { user in
//                VStack(alignment: .leading) {
//                    Text(user.name)
//                        .font(.headline)
//                    Text("Status: \(user.status)")
//                        .font(.subheadline)
//                        .foregroundColor(.secondary)
//                }
//            }
//        }
//        .navigationTitle("Users")
//        .task {
//            await fetchUsers()
//            print("🚀 Fetching users...")
//        }
//    }
//}
//
//func fetchUsers() async {
//    do {
//        let response = try await supabaseManager
//            .from("users")
//            .select()
//            .execute()
//        
//        let data = response
//        
//        print("🔹 Raw data: \(data)")
//        
//        let decoder = JSONDecoder()
//        let decoded = try decoder.decode([User].self, from: response.data)
//        print("✅ Decoded:", decoded)
//        
////        UserService.self.user = decoded
//    } catch {
//        print("❌ Error:", error)
//    }
//}
