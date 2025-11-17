//
//  IdeaListView.swift
//  ADA_C6-sunrice
//
//  Created by Selena Aura on 15/11/25.
//
import SwiftUI

//struct IdeaListView: View {
//    @EnvironmentObject var navVM: NavigationViewModel
//    
//    @State private var ideas: [Idea] = []
//    @State private var isLoading = false
//    
//    var body: some View {
//        if isLoading {
//            ProgressView("Loading ideas...")
//        } else {
//            List(ideas) { idea in
//                IdeaBubbleView(
//                    text: idea.text,
//                    ideaId: idea.id ?? 1
//                ) { tappedId in
//                    navVM.path.append(Route.comment(ideaId: tappedId))
//
//                }
//            }
//            .listRowSeparator(.hidden)
//        }
//    }
//    
//    func fetchIdeas() async {
//        isLoading = true
//        do {
//            let response = try await supabaseManager
//                .from("ideas")
//                .select()
//                .execute()
//            
//            let decoder = JSONDecoder()
//            let decoded = try decoder.decode([Idea].self, from: response.data)
//            
//            ideas = decoded
//        } catch {
//            print("❌ Error:", error)
//        }
//        isLoading = false
//    }
//}
