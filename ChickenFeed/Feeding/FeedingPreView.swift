//
//  FeedingPreView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct FeedingPreView: View {
    var feeding: FeedingModel

    var body: some View {
        HStack (alignment: .top) {
            feeding.type.image
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.yellowAccent)
                .frame(width: 20, height: 20)
                .padding(10)
                .background(Circle().fill(.lightAccent))
            VStack (alignment: .leading, spacing: 0) {
                Text("\(feeding.name)")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white)
                    .padding(.bottom, 2)
                Text("\(feeding.date.formatted(date: .omitted, time: .shortened))")
                    .font(.system(size: 12, weight: .regular))
                    .foregroundStyle(.lightAccent)
                Text("\(feeding.type.rawValue) - \(String(format: "%.1f", feeding.quantity)) \(feeding.quantityUnit.rawValue)")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundStyle(.white)
                    .padding(.vertical, 9)
                Text(feeding.note)
                    .font(.system(size: 12, weight: .light))
                    .italic()
                    .foregroundStyle(.lightAccent)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .darkFramed()
    }
}

#Preview {
    FeedingPreView(feeding: FeedingModel(date: .now, type: .grain, quantity: 25, quantityUnit: .grams, note: "Birds were active and ate well. Noticed two hens were less interested in feed."))
}
