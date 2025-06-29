//
//  RecipeModel.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import Foundation

struct RecipeModel: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var category: RecipeCategory
    var ingredients: [IngredientModel]
    var note: String
    var imageData: Data?
}

enum RecipeCategory: String, CaseIterable, Codable {
    case grainMix = "Grain Mix"
    case mashFeed = "Mash Feed"
    case proteinSupplement = "Protein Supplement"
    case vitaminMix = "Vitamin Mix"
}
