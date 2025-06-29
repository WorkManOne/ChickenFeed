//
//  CustomToggleStyle.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import Foundation
import SwiftUI

struct CustomToggleStyle: ToggleStyle {
    var foregroundColor: Color = .white
    var offBackgroundColor: Color = .lightAccent

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            Spacer()
            RoundedRectangle(cornerRadius: 16)
                .fill(configuration.isOn ? Color.yellow : offBackgroundColor)
                .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                .frame(width: 50, height: 30)
                .overlay(
                    Circle()
                        .fill(foregroundColor)
                        .frame(width: 24, height: 24)
                        .offset(x: configuration.isOn ? 10 : -10)
                        .animation(.easeInOut(duration: 0.2), value: configuration.isOn)
                )
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
    }
}
