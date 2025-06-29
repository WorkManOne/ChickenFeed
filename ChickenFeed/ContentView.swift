//
//  ContentView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userData: DataModel
    @EnvironmentObject var calculator: CalculatorModel
    
    var body: some View {
        NavigationStack {
            VStack (alignment: .leading) {
                HStack (alignment: .top) {
                    Image("feather")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 30)
                    Text("ChickenFeed")
                        .foregroundStyle(.white)
                        .font(.system(size: 20, weight: .medium))
                        .multilineTextAlignment(.center)
                        .padding(.bottom)
                    Spacer()
                }
                .padding(.top, 40)
                Spacer()
                Text("Quick Actions")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.vertical, 10)
                HStack {
                    NavigationLink {
                        AddFeedingView()
                    } label: {
                        SmallButton(image: Image(systemName: "plus"), title: "Add Feeding")
                    }
                    NavigationLink {
                        AddRecipeView()
                    } label: {
                        SmallButton(image: Image("book"), title: "New Recipe")
                    }
                    NavigationLink {
                        CalculatorView()
                    } label: {
                        SmallButton(image: Image("calculator"), title: "Calculate")
                    }
                }
                Text("My Flock")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.vertical, 10)
                VStack (alignment: .leading) {
                    HStack {
                        VStack (alignment: .leading) {
                            Text("Total Birds")
                                .foregroundStyle(.lightAccent)
                                .font(.system(size: 14, weight: .regular))
                                .padding(.bottom, 1)
                            Text("\(calculator.chickenAmount)")
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .medium))
                        }
                        Spacer()
                        VStack (alignment: .leading) {
                            Text("Feed Consumption")
                                .foregroundStyle(.lightAccent)
                                .font(.system(size: 14, weight: .regular))
                                .padding(.bottom, 1)
                            Text("\(String(format: "%.1f", Double(calculator.proteins + calculator.fats + calculator.carbohydrates + calculator.vitamins) / 1000)) kg/day")
                                .foregroundStyle(.white)
                                .font(.system(size: 20, weight: .medium))
                        }

                    }
                    let fed = Double(calculator.fedProteins + calculator.fedFats + calculator.fedCarbohydrates + calculator.fedVitamins)
                    let target = Double(calculator.proteins + calculator.fats + calculator.carbohydrates + calculator.vitamins)
                    let progress = target == 0 ? 0 : min(max(1 - fed / target, 0), 1)
                    CustomProgressBar(progress: progress)
                    Text("Feed stock: \(String(format: "%.0f", progress*100))% remaining")
                        .foregroundStyle(.lightAccent)
                        .font(.system(size: 14, weight: .regular))
                        .padding(.top, 2)
                }
                .darkFramed()
                Text("Manage Feeding")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
                    .padding(.vertical, 10)
                HStack (spacing: 15) {
                    NavigationLink {
                        FeedingView()
                    } label: {
                        SmallButton(image: Image("calendar2"), title: "Feeding Diary", description: "Track daily feedings", isStyle: true)
                    }
                    NavigationLink {
                        RecipesView()
                    } label: {
                        SmallButton(image: Image(systemName: "fork.knife"), title: "Feed Recipes", description: "Custom feed formulas", isStyle: true)
                    }
                }
                .padding(.bottom, 10)
                HStack (spacing: 15) {
                    NavigationLink {
                        CalculatorView()
                    } label: {
                        SmallButton(image: Image("calculator"), title: "Feed Calculator", description: "Calculate nutritional needs", isStyle: true)
                    }
                    NavigationLink {
                        SettingsView()
                    } label: {
                        SmallButton(image: Image("gear"), title: "Settings", description: """
                                    Configure your app
                                    
                                    """, isStyle: true)
                    }
                }
                Spacer()
            }
            .padding(.horizontal, 20)
            .background(Color.backgroundAccent)
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(DataModel())
}
