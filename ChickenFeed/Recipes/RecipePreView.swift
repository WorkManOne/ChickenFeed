//
//  RecipePreView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 28.06.2025.
//

import SwiftUI

struct RecipePreView: View {
    var recipe: RecipeModel

    var body: some View {
        VStack (alignment: .leading) {
            if let data = recipe.imageData, let image = UIImage(data: data) {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 180)
                    .clipped()
            }
            VStack (alignment: .leading) {
                Text(recipe.name)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.leading)
                Text(recipe.note)
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.lightAccent)
                    .padding(.bottom, 10)
                    .multilineTextAlignment(.leading)
                HStack {
                    Image("caveat")
                    Text("\(recipe.ingredients.count) \(recipe.ingredients.count == 1 ? "ingredient" : "ingredients")")
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                }
            }
            .padding()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .overlay {
            VStack {
                HStack {
                    Spacer()
                    Text(recipe.category.rawValue)
                        .font(.system(size: 12, weight: .regular))
                        .foregroundStyle(.black)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.yellowAccent)
                        )
                        .padding()
                }
                Spacer()
            }
        }
        .background(.darkAccent)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
//
//struct RecipePreView: View {
//    var recipe: RecipeModel
//
//    var body: some View {
//        VStack(spacing: 0) {
//            ZStack(alignment: .topTrailing) {
//                if let data = recipe.imageData,
//                   let image = UIImage(data: data) {
//                    Image(uiImage: image)
//                        .resizable()
//                        .scaledToFill()
//                        .frame(height: 180)
//                        .clipped() // важно: чтобы не выходила за рамки
//                } else {
//                    Rectangle()
//                        .fill(.gray)
//                        .frame(height: 180)
//                }
//
//                Text(recipe.category.rawValue)
//                    .font(.system(size: 12, weight: .regular))
//                    .foregroundStyle(.black)
//                    .padding(8)
//                    .background(
//                        RoundedRectangle(cornerRadius: 10)
//                            .fill(.yellowAccent)
//                    )
//                    .padding(10)
//            }
//            VStack(alignment: .leading, spacing: 8) {
//                Text(recipe.name)
//                    .font(.system(size: 18, weight: .medium))
//                    .foregroundStyle(.white)
//
//                Text(recipe.note)
//                    .font(.system(size: 14, weight: .regular))
//                    .foregroundStyle(.lightAccent)
//
//                HStack(spacing: 6) {
//                    Image("caveat")
//                    Text("\(recipe.ingredients.count) \(recipe.ingredients.count == 1 ? "ingredient" : "ingredients")")
//                        .font(.system(size: 12, weight: .regular))
//                        .foregroundStyle(.white)
//                }
//            }
//            .padding(12)
//            .frame(maxWidth: .infinity, alignment: .leading)
//            .background(Color.darkAccent)
//        }
//        .clipShape(RoundedRectangle(cornerRadius: 14))
//        .overlay(
//            RoundedRectangle(cornerRadius: 14)
//                .stroke(Color.lightAccent, lineWidth: 1)
//        )
//        .padding(.horizontal)
//    }
//}


#Preview {
    RecipePreView(recipe: RecipeModel(name: "Balanced Layer Mix", category: .grainMix, ingredients: [IngredientModel(name: "aasd", amount: 0.3123, unit: .kilograms)], note: "Complete nutrition for laying hens with optimal calcium and protein balance."))
}
