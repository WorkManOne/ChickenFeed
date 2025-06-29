//
//  RecipeDetailView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct RecipeDetailView: View {
    @Environment(\.dismiss) var dismiss
    var recipe: RecipeModel

    var body: some View {
        ScrollView {
            VStack (alignment: .leading) {
                Text(recipe.category.rawValue)
                    .font(.system(size: 24, weight: .regular))
                    .foregroundStyle(.yellowAccent)
                    .multilineTextAlignment(.leading)
                if let imageData = recipe.imageData,
                   let selectedImage = UIImage(data: imageData) {
                    Image(uiImage: selectedImage)
                        .resizable()
                        .scaledToFill()
                        .frame(height: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                Text(recipe.note)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 15)
                Text("Ingredients")
                    .font(.system(size: 18, weight: .regular))
                    .foregroundStyle(.white)
                VStack (spacing: 0) {
                    ForEach(Array(recipe.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                        VStack (spacing: 0) {
                            HStack {
                                Circle()
                                    .fill(.yellowAccent)
                                    .frame(width: 10, height: 10)
                                Text(ingredient.name)
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundStyle(.white)
                                Spacer()
                                Text("\(String(format: "%.2f", ingredient.amount)) \(ingredient.unit.rawValue)")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundStyle(.yellowAccent)
                            }
                            if index < recipe.ingredients.count - 1 {
                                Rectangle()
                                    .fill(.lightAccent.opacity(0.3))
                                    .frame(height: 1)
                                    .padding(.top)
                                    .padding(.bottom)
                            }
                        }
                    }
                }
                .darkFramed()
            }
            .padding(.horizontal, 20)
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
                Text(recipe.name)
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
    RecipeDetailView(recipe: RecipeModel(name: "", category: .grainMix, ingredients: [IngredientModel(name: "some ingredient name", amount: 123.75, unit: .kilograms), IngredientModel(name: "some ingredient name", amount: 123.75, unit: .kilograms)], note: "A balanced feed formula specifically designed for laying hens to maximize egg production while maintaining optimal health."))
}
