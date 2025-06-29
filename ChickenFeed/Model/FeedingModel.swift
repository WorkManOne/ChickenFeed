//
//  FeedingModel.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import Foundation
import SwiftUI

struct FeedingModel: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var type: FeedingType
    var quantity: Double
    var quantityUnit: MeasurementUnit
    var note: String
    var name: String {
        let hour = Calendar.current.component(.hour, from: date)
        
        switch hour {
        case 5..<11:
            return "Morning Feed"
        case 11..<16:
            return "Afternoon Feed"
        case 16..<21:
            return "Evening Feed"
        default:
            return "Night Feed"
        }
    }
}

enum FeedingType: String, CaseIterable, Codable {
    case grain = "Grain"
    case greens = "Greens"
    case protein = "Protein"
    case supplement = "Supplement"
    case water = "Water"
    case other = "Other"
    
    var image: Image {
        switch self {
        case .grain:
            Image("caveat")
        case .greens:
            Image("leaf")
        case .protein:
            Image("meat")
        case .supplement:
            Image("bowl")
        case .water:
            Image(systemName: "waterbottle.fill")
        case .other:
            Image(systemName: "ellipsis")
        }
    }
    
    func proteinsPer100g() -> Double {
        switch self {
        case .grain: return 12.0
        case .greens: return 2.0
        case .protein: return 25.0
        case .supplement: return 0.0
        case .water: return 0.0
        case .other: return 5.0
        }
    }
    
    func fatsPer100g() -> Double {
        switch self {
        case .grain: return 5.0
        case .greens: return 0.5
        case .protein: return 10.0
        case .supplement: return 0.0
        case .water: return 0.0
        case .other: return 2.0
        }
    }
    
    func carbsPer100g() -> Double {
        switch self {
        case .grain: return 65.0
        case .greens: return 4.0
        case .protein: return 0.0
        case .supplement: return 0.0
        case .water: return 0.0
        case .other: return 20.0
        }
    }
    
    func vitaminsPer100g() -> Double {
        switch self {
        case .grain: return 1.0
        case .greens: return 3.0
        case .protein: return 1.0
        case .supplement: return 10.0
        case .water: return 0.0
        case .other: return 1.0
        }
    }
}
