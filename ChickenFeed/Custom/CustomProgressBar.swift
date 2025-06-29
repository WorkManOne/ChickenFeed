//
//  YellowProgressBar.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 25.06.2025.
//

import Foundation
import SwiftUI

struct CustomProgressBar: View {
    var progress: Double
    var foregroundColor: Color = .yellowAccent
    var backgroundColor: Color = .lightAccent
    var height: CGFloat = 10

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 6)
                    .fill(backgroundColor)
                    .frame(height: height)
                RoundedRectangle(cornerRadius: 6)
                    .fill(foregroundColor)
                    .frame(width: geometry.size.width * min(max(progress, 0), 1), height: height)
            }
        }
        .frame(height: height)
    }
}
