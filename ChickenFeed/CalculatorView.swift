//
//  CalculatorView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct CalculatorView: View {
    @EnvironmentObject var userData: DataModel
    @EnvironmentObject var calculator: CalculatorModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ScrollView {
            if calculator.isCalculated {
                VStack (alignment: .leading, spacing: 20) {
                    HStack {
                        Text("Daily nutritional needs")
                            .font(.system(size: 18))
                            .foregroundStyle(.white)
                        Spacer()
                        Text("Per Day")
                            .font(.system(size: 12))
                            .foregroundStyle(.black)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(
                                RoundedRectangle(cornerRadius: 5)
                                    .fill(.yellowAccent)
                            )
                    }
                    ResultRow(image: "meat", name: "Proteins", value: calculator.fedProteins, targetValue: calculator.proteins, textPercentage: "16-18")
                    ResultRow(image: "teapot", name: "Fats", value: calculator.fedFats, targetValue: calculator.fats, textPercentage: "4-5")
                    ResultRow(image: "caveat", name: "Carbohydrates", value: calculator.fedCarbohydrates, targetValue: calculator.carbohydrates, textPercentage: "65-70")
                    ResultRow(image: "vits", name: "Vitamins/supplements", value: calculator.fedVitamins, targetValue: calculator.vitamins, textPercentage: "1-2")
                    Button {
                        withAnimation {
                            calculator.isCalculated = false
                        }
                    } label: {
                        HStack {
                            Image("calculator")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.black)
                                .scaledToFit()
                                .frame(height: 16)
                            Text("Recalculate")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.yellowAccent)
                        )
                    }
                    .padding(.top)

                }
                .padding(.horizontal, 20)
                .transition(.asymmetric(insertion: .push(from: .trailing), removal: .push(from: .leading)))
            } else {
                VStack (alignment: .leading) {
                    HStack (alignment: .top) {
                        Image("calculator")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        VStack (alignment: .leading) {
                            Text("Feed Requirement Calculator")
                                .font(.system(size: 16))
                                .foregroundStyle(.white)
                            Text("Calculate the optimal feed amounts based on your flock's size, age, and type.")
                                .font(.system(size: 14))
                                .foregroundStyle(.lightAccent)
                                .multilineTextAlignment(.leading)
                        }
                    }
                    .darkFramed()
                    .padding(.bottom)
                    Text("Number of Chickens")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    HStack {
                        TextField("0", text: Binding(
                            get: {
                                calculator.chickenAmount == 0 ? "" : String(calculator.chickenAmount)
                            },
                            set: { newValue in
                                calculator.chickenAmount = Int(newValue) ?? calculator.chickenAmount
                            }
                        ), prompt: Text("0").foregroundColor(.lightAccent))
                        .keyboardType(.numberPad)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .regular))
                        Image("feather")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(.lightAccent)
                            .frame(height: 16)
                    }
                    .darkFramed(isBordered: true)
                    .padding(.bottom)
                    Text("Age (in weeks)")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    HStack {
                        TextField("0", text: Binding(
                            get: {
                                String(calculator.age)
                            },
                            set: { newValue in
                                calculator.age = Int(newValue) ?? calculator.age
                            }
                        ), prompt: Text("0").foregroundColor(.lightAccent))
                        .keyboardType(.numberPad)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .regular))
                        Image("calendar2")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .foregroundStyle(.lightAccent)
                            .frame(height: 16)
                    }
                    .darkFramed(isBordered: true)
                    .padding(.bottom)
                    Text("Chicken Type")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    HStack {
                        Button {
                            calculator.isBroilers = false
                        } label: {
                            VStack (spacing: 8) {
                                Image("egg")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Text("Layers")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                Text("Egg production")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.lightAccent)
                                    .multilineTextAlignment(.leading)
                            }.darkFramed()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(!calculator.isBroilers ? .yellowAccent : .lightAccent, lineWidth: 1)
                                }
                        }

                        Button {
                            calculator.isBroilers = true
                        } label: {
                            VStack (spacing: 8) {
                                Image("meat")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(height: 20)
                                Text("Broilers")
                                    .font(.system(size: 16))
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                Text("Meat production")
                                    .font(.system(size: 12))
                                    .foregroundStyle(.lightAccent)
                                    .multilineTextAlignment(.leading)
                            }.darkFramed()
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(calculator.isBroilers ? .yellowAccent : .lightAccent, lineWidth: 1)
                                }
                        }
                    }
                    .padding(.bottom)
                    Text("Chicken Type")
                        .font(.system(size: 14))
                        .foregroundStyle(.white)
                    VStack {
                        HStack {
                            Image("leaf")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                            Text("Free-range supplement")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                            Toggle(isOn: $calculator.isFreeRange, label: {})
                                .toggleStyle(CustomToggleStyle(foregroundColor: .darkAccent))
                        }
                        HStack {
                            Image("caveat")
                                .resizable()
                                .scaledToFit()
                                .frame(height: 16)
                            Text("Custom feed formula")
                                .font(.system(size: 14))
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                            Toggle(isOn: $calculator.isCustomFeed, label: {})
                                .toggleStyle(CustomToggleStyle(foregroundColor: .darkAccent))
                        }
                    }.darkFramed()
                        .padding(.bottom)
                    Button {
                        withAnimation {
                            calculator.calculateNutrients()
                        }
                    } label: {
                        HStack {
                            Image("calculator")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundStyle(.black)
                                .scaledToFit()
                                .frame(height: 16)
                            Text("Calculate Feed Requirements")
                                .font(.system(size: 16))
                                .foregroundStyle(.black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(.yellowAccent)
                        )
                    }


                }
                .padding(.horizontal, 20)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle("")
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.white)
                }
            }
            ToolbarItem(placement: .principal) {
                Text("Feed Calculator")
                    .font(.system(size: 20, weight: .bold))
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
               let window = windowScene.windows.first,
               let nav = window.rootViewController?.children.first as? UINavigationController {
                nav.interactivePopGestureRecognizer?.isEnabled = true
                nav.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        .background(.backgroundAccent)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

struct ResultRow: View {
    var image: String
    var name: String
    var value: Double
    var targetValue: Double
    var textPercentage: String

    var body: some View {
        VStack (alignment: .leading) {
            HStack {
                Image(image)
                    .renderingMode(.template)
                    .resizable()
                    .foregroundStyle(.yellowAccent)
                    .scaledToFit()
                    .frame(width: 16, height: 16)
                    .padding(10)
                    .background(
                        Circle()
                            .fill(.lightAccent)
                    )
                Text(name)
                    .font(.system(size: 16))
                    .foregroundStyle(.white)
                Spacer()
                Text(targetValue >= 1000
                     ? String(format: "%.2fkg", targetValue / 1000)
                     : String(format: "%.0fg", targetValue))
                    .font(.system(size: 16))
                    .foregroundStyle(.yellowAccent)
            }
            CustomProgressBar(progress: value / targetValue, backgroundColor: .lightAccent.opacity(0.3))
                .padding(.bottom, 5)
            Text("\(textPercentage)% of total feed")
                .font(.system(size: 12))
                .foregroundStyle(.lightAccent)
        }.darkFramed()
    }
}

#Preview {
    CalculatorView()
        .environmentObject(DataModel())
}
