//
//  AddFeedingView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct AddFeedingView: View {
    let isEditing: Bool
    @EnvironmentObject var userData: DataModel
    @Environment(\.dismiss) var dismiss
    @State private var feeding: FeedingModel = FeedingModel(date: .now, type: .grain, quantity: 0, quantityUnit: .kilograms, note: "")
    @State private var showingDatePicker = false
    @State private var showingTimePicker = false

    init(feeding: FeedingModel? = nil) {
        if let feeding = feeding {
            self._feeding = State(initialValue: feeding)
            isEditing = true
        } else {
            self._feeding = State(initialValue: FeedingModel(date: .now, type: .grain, quantity: 0, quantityUnit: .kilograms, note: ""))
            isEditing = false
        }
    }
    var body: some View {
        ZStack {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Date & Time")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.lightAccent)
                    HStack {
                        Button {
                            showingDatePicker = true
                        } label: {
                            HStack {
                                Image("calendar")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                Text(feeding.date.formatted(.iso8601.year().month().day().dateSeparator(.dash)))
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .regular))
                            }
                        }

                        Spacer()
                        Button {
                            showingTimePicker = true
                        } label: {
                            HStack {
                                Image("clock")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 15, height: 15)
                                Text(feeding.date.formatted(date: .omitted, time: .shortened))
                                    .foregroundStyle(.white)
                                    .font(.system(size: 16, weight: .regular))
                            }
                        }
                        Spacer()
                    }
                    .darkFramed()
                    .padding(.bottom, 20)
                    Text("Feed Type")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.lightAccent)
                    HStack {
                        TypePickView(type: .grain, selectedType: $feeding.type)
                        TypePickView(type: .greens, selectedType: $feeding.type)
                        TypePickView(type: .protein, selectedType: $feeding.type)
                    }
                    HStack {
                        TypePickView(type: .supplement, selectedType: $feeding.type)
                        TypePickView(type: .water, selectedType: $feeding.type)
                        TypePickView(type: .other, selectedType: $feeding.type)
                    }
                    .padding(.bottom, 20)
                    Text("Quantity")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.lightAccent)
                    HStack {
                        Image("weights")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                        TextField("0.0", text: Binding(
                            get: {
                                feeding.quantity == 0 ? "" : String(format: "%.2f", feeding.quantity)
                            },
                            set: { newValue in
                                let filtered = newValue.filter { $0.isNumber || $0 == "." || $0 == "," }
                                let normalizedValue = filtered.replacingOccurrences(of: ",", with: ".")
                                feeding.quantity = Double(normalizedValue) ?? feeding.quantity
                            }
                        ))
                        .keyboardType(.decimalPad)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .regular))
                        Rectangle()
                            .fill(.lightAccent)
                            .frame(width: 1)
                        Picker("Unit", selection: $feeding.quantityUnit) {
                            ForEach(MeasurementUnit.allCases) { unit in
                                Text(unit.rawValue)
                                    .foregroundStyle(.white)
                                    .tag(unit)
                            }
                        }
                        .pickerStyle(.menu)
                        .tint(.white)
                        Spacer()
                    }
                    .darkFramed()
                    .padding(.bottom)
                    Text("Notes")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.lightAccent)
                    TextEditor(text: $feeding.note)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .regular))
                        .frame(minHeight: 100)
                        .darkFramed()
                        .padding(.bottom)
                    Button {
                        if isEditing {
                            if let index = userData.feedings.firstIndex(where: { $0.id == feeding.id }) {
                                userData.feedings[index] = feeding
                            }
                        } else {
                            userData.feedings.append(feeding)
                        }
                        NotificationManager.shared.scheduleFeedingReminder(for: feeding)
                        dismiss()
                    } label: {
                        Text("Save")
                            .font(.system(size: 16, weight: .regular))
                            .foregroundStyle(.black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(.yellowAccent)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
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
                Text(isEditing ? "Editing" : "Adding")
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
        .sheet(isPresented: $showingDatePicker) {
            CustomDatePickerSheet(selectedDate: $feeding.date)
        }
        .sheet(isPresented: $showingTimePicker) {
            CustomTimePickerSheet(selectedDate: $feeding.date)
        }
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

struct TypePickView: View {
    let type: FeedingType
    @Binding var selectedType: FeedingType

    var body : some View {
        Button {
            selectedType = type
        } label: {
            SmallButton(image: type.image, title: type.rawValue)
                .overlay {
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.yellowAccent, lineWidth: 2)
                        .opacity(selectedType == type ? 1 : 0)
                }
        }
    }
}


#Preview {
    AddFeedingView()
        .environmentObject(DataModel())
        .background(.backgroundAccent)
}
