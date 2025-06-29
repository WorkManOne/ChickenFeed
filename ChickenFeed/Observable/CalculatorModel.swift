//
//  CalculatorModel.swift
//  ChickenFeed
//
//  Created by Кирилл Архипов on 29.06.2025.
//

import Foundation


class CalculatorModel: ObservableObject, Codable {
    static let shared = CalculatorModel()

    @Published var chickenAmount: Int = 0
    @Published var age: Int = 0
    @Published var isBroilers: Bool = false
    @Published var isFreeRange: Bool = false
    @Published var isCustomFeed: Bool = false

    @Published var proteins: Double = 0
    @Published var fats: Double = 0
    @Published var carbohydrates: Double = 0
    @Published var vitamins: Double = 0

    @Published var fedProteins: Double = 0
    @Published var fedFats: Double = 0
    @Published var fedCarbohydrates: Double = 0
    @Published var fedVitamins: Double = 0

    @Published var fedTotal = 0.0
    @Published var isCalculated: Bool = false

    private static func load() -> CalculatorModel {
        if let data = UserDefaults.standard.data(forKey: "calculator"),
           let decoded = try? JSONDecoder().decode(CalculatorModel.self, from: data) {
            return decoded
        } else {
            return CalculatorModel()
        }
    }

    private func save() {
        if let encoded = try? JSONEncoder().encode(self) {
            UserDefaults.standard.set(encoded, forKey: "calculator")
        }
    }

    private init() {
        if let data = UserDefaults.standard.data(forKey: "calculator"),
           let decoded = try? JSONDecoder().decode(CalculatorModel.self, from: data) {
            chickenAmount = decoded.chickenAmount
            age = decoded.age
            isBroilers = decoded.isBroilers
            isFreeRange = decoded.isFreeRange
            isCustomFeed = decoded.isCustomFeed
            proteins = decoded.proteins
            fats = decoded.fats
            carbohydrates = decoded.carbohydrates
            vitamins = decoded.vitamins
            fedProteins = decoded.fedProteins
            fedFats = decoded.fedFats
            fedCarbohydrates = decoded.fedCarbohydrates
            fedVitamins = decoded.fedVitamins
            fedTotal = decoded.fedTotal
            isCalculated = decoded.isCalculated
        }
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        chickenAmount = try container.decode(Int.self, forKey: .chickenAmount)
        age = try container.decode(Int.self, forKey: .age)
        isBroilers = try container.decode(Bool.self, forKey: .isBroilers)
        isFreeRange = try container.decode(Bool.self, forKey: .isFreeRange)
        isCustomFeed = try container.decode(Bool.self, forKey: .isCustomFeed)
        proteins = try container.decode(Double.self, forKey: .proteins)
        fats = try container.decode(Double.self, forKey: .fats)
        carbohydrates = try container.decode(Double.self, forKey: .carbohydrates)
        vitamins = try container.decode(Double.self, forKey: .vitamins)
        fedProteins = try container.decode(Double.self, forKey: .fedProteins)
        fedFats = try container.decode(Double.self, forKey: .fedFats)
        fedCarbohydrates = try container.decode(Double.self, forKey: .fedCarbohydrates)
        fedVitamins = try container.decode(Double.self, forKey: .fedVitamins)
        fedTotal = try container.decode(Double.self, forKey: .fedTotal)
        isCalculated = try container.decode(Bool.self, forKey: .isCalculated)
    }

    func calculateFeeded(feedings: [FeedingModel]) {
        var totalProtein: Double = 0
        var totalFat: Double = 0
        var totalCarbs: Double = 0
        var totalVitamins: Double = 0

        let today = Calendar.current.startOfDay(for: Date())
        let todayFeedings = feedings.filter { feeding in
            Calendar.current.startOfDay(for: feeding.date) == today
        }
        for feeding in todayFeedings {
            let grams = convertToGramsOrML(quantity: feeding.quantity, unit: feeding.quantityUnit)
            totalProtein += (feeding.type.proteinsPer100g() / 100) * grams
            totalFat += (feeding.type.fatsPer100g() / 100) * grams
            totalCarbs += (feeding.type.carbsPer100g() / 100) * grams
            totalVitamins += (feeding.type.vitaminsPer100g() / 100) * grams
        }

        fedProteins = totalProtein
        fedFats = totalFat
        fedCarbohydrates = totalCarbs
        fedVitamins = totalVitamins
        save()
    }

    func calculateNutrients() {
        var dailyIntakePerChicken: Double {
            switch age {
            case 0..<6:
                return isBroilers ? 30 : 25
            case 6..<12:
                return isBroilers ? 60 : 50
            case 12..<18:
                return isBroilers ? 100 : 90
            default:
                return isBroilers ? 120 : 100
            }
        }

        let dailyTotalIntake = Double(chickenAmount) * dailyIntakePerChicken
        let typeMultiplier = isBroilers ? 1.2 : 1.0
        let freeRangeMultiplier = isFreeRange ? 1.1 : 1.0
        let customFeedMultiplier = isCustomFeed ? 1.15 : 1.0

        let totalMultiplier = typeMultiplier * freeRangeMultiplier * customFeedMultiplier
        let adjustedIntake = dailyTotalIntake * totalMultiplier

        proteins = adjustedIntake * 0.20
        fats = adjustedIntake * 0.05
        carbohydrates = adjustedIntake * 0.70
        vitamins = adjustedIntake * 0.05
        isCalculated = true
        save()
    }

    func convertToGramsOrML(quantity: Double, unit: MeasurementUnit) -> Double {
        switch unit {
        case .grams, .milliliters:
            return quantity
        case .kilograms, .liters:
            return quantity * 1000
        case .handfuls:
            return quantity * 30
        case .buckets:
            return quantity * 10000
        case .scoops:
            return quantity * 100
        case .pieces:
            return quantity * 50
        case .other:
            return quantity * 100
        }
    }
}

extension CalculatorModel {
    enum CodingKeys: String, CodingKey {
        case chickenAmount, age, isBroilers, isFreeRange, isCustomFeed
        case proteins, fats, carbohydrates, vitamins
        case fedProteins, fedFats, fedCarbohydrates, fedVitamins, fedTotal, isCalculated
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(chickenAmount, forKey: .chickenAmount)
        try container.encode(age, forKey: .age)
        try container.encode(isBroilers, forKey: .isBroilers)
        try container.encode(isFreeRange, forKey: .isFreeRange)
        try container.encode(isCustomFeed, forKey: .isCustomFeed)
        try container.encode(proteins, forKey: .proteins)
        try container.encode(fats, forKey: .fats)
        try container.encode(carbohydrates, forKey: .carbohydrates)
        try container.encode(vitamins, forKey: .vitamins)
        try container.encode(fedProteins, forKey: .fedProteins)
        try container.encode(fedFats, forKey: .fedFats)
        try container.encode(fedCarbohydrates, forKey: .fedCarbohydrates)
        try container.encode(fedVitamins, forKey: .fedVitamins)
        try container.encode(fedTotal, forKey: .fedTotal)
        try container.encode(isCalculated, forKey: .isCalculated)
    }
}
