//
//  IngredientModel.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import Foundation

struct IngredientModel: Identifiable, Codable {
    var id: UUID = UUID()
    var name: String
    var amount: Double
    var unit: MeasurementUnit
}

enum MeasurementUnit: String, CaseIterable, Codable, Identifiable {
    case kilograms = "kg"
    case grams = "g"
    case liters = "L"
    case milliliters = "mL"
    case pieces = "pcs"
    case handfuls = "handful"
    case buckets = "bucket"
    case scoops = "scoop"
    case other = "other"

    var id: String { rawValue }
}
