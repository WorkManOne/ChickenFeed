//
//  OnboardingView.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 23.06.2025.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject var userData: DataModel
    @State private var selectedIndex = 0

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button {
                    userData.isFirstLaunch = false
                } label: {
                    Text("Skip")
                        .foregroundStyle(.yellowAccent)
                        .font(.system(size: 14, weight: .regular))
                }

            }
            .padding(.horizontal, 20)
            Spacer()
            Spacer()
            HStack (alignment: .top) {
                Image("feather")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(height: 30)
                Text("ChickenFeed")
                    .foregroundStyle(.white)
                    .font(.system(size: 24, weight: .bold))
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
            }
            Text("Welcome to ChickenFeed")
                .foregroundStyle(.white)
                .font(.system(size: 20, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .padding(.bottom)
            Text("Your complete solution for managing chicken feeding")
                .foregroundStyle(.lightAccent)
                .font(.system(size: 14, weight: .regular))
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            TabView (selection: $selectedIndex) {
                TipView(image: Image("calendar2"), title: "Feeding Diary", description: "Log daily feedings and track what your chickens eat, when, and how much.")
                    .tag(0)
                TipView(image: Image(systemName: "fork.knife"), title: "Homemade Feed Recipes", description: "Access easy-to-follow recipes for grain mixes, mashes, protein, and vitamin supplements.")
                    .tag(1)
                TipView(image: Image("calculator"), title: "Feed Calculator", description: "Calculate the exact amount of nutrients your chickens need based on their age, type, and number.")
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .frame(height: 300)
            Spacer()
            Spacer()
            HStack(spacing: 8) {
                ForEach(0..<3, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 8)
                        .fill(index == selectedIndex ? Color.yellowAccent : Color.lightAccent)
                        .frame(width: index == selectedIndex ? 25 : 8, height: 8)
                        .animation(.easeInOut, value: selectedIndex)
                }
            }
            VStack {
                Button {
                    if selectedIndex == 2 {
                        userData.isFirstLaunch = false
                    } else {
                        withAnimation {
                            selectedIndex = selectedIndex + 1
                        }

                    }
                } label: {
                    HStack {
                        Text("Get Started")
                        Image(systemName: "arrow.right")
                    }
                    .foregroundStyle(.black)
                    .font(.system(size: 16, weight: .bold))
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.yellowAccent)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .padding(.horizontal, 20)
                .padding(.vertical)
            }
        }
        .background(.backgroundAccent)
    }
}

struct TipView: View {
    let image: Image
    let title: String
    let description: String

    var body: some View {
        VStack {
            image
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundStyle(.yellowAccent)
                .padding(.horizontal)
                .padding(.vertical, 20)
                .background(
                    Circle()
                        .fill(.lightAccent)
                )
                .padding(.bottom, 10)
            VStack {
                Text(title)
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .medium))
                    .multilineTextAlignment(.leading)
                    .padding(.bottom, 7)
                Text(description)
                    .foregroundStyle(.lightAccent)
                    .font(.system(size: 14, weight: .regular))
                    .multilineTextAlignment(.center)
            }
        }
        .padding()
        .darkFramed()
        .padding(.horizontal, 20)
    }
}

#Preview {
    OnboardingView()
        .background(.black)
        .environmentObject(DataModel())
}
