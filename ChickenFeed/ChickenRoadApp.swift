//
//  ChickenRoadApp.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

@main
struct ChickenFeedApp: App {
    @ObservedObject var calculator = CalculatorModel.shared
    @ObservedObject var userData = DataModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userData)
                .environmentObject(calculator)
                .preferredColorScheme(.dark)
                .fullScreenCover(isPresented: .constant(userData.isFirstLaunch)) {
                    OnboardingView()
                        .environmentObject(userData)
                }
        }
    }
}
