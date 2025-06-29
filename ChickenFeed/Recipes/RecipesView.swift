//
//  RecipesView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct RecipesView: View {
    @EnvironmentObject var userData: DataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(userData.recipes) { recipe in
                        NavigationLink {
                            RecipeDetailView(recipe: recipe)
                        } label: {
                            RecipePreView(recipe: recipe)
                                .id(recipe.id)
                                .contextMenu {
                                    NavigationLink {
                                        AddRecipeView(recipe: recipe)
                                    } label: {
                                        Text("Edit")
                                    }
                                    Button {
                                        withAnimation {
                                            if let index = userData.recipes.firstIndex(where: { $0.id == recipe.id } ) {
                                                userData.recipes.remove(at: index)
                                            }
                                        }
                                    } label: {
                                        Text("Delete")
                                    }
                                }
                        }
                    }
                }
                .padding(.horizontal, 20)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        AddRecipeView()
                    } label: {
                        Image(systemName: "plus")
                            .foregroundStyle(.black)
                            .font(.system(size: 25))
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(.yellowAccent)
                            )
                            .padding(20)
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Feeding Diary")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let nav = window.rootViewController?.children.first as? UINavigationController {
                nav.interactivePopGestureRecognizer?.isEnabled = true
                nav.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        .background(.backgroundAccent)
    }

}

#Preview {
    RecipesView()
        .environmentObject(DataModel())
}
