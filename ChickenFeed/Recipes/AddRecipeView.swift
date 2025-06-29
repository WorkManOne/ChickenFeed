//
//  AddRecipeView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct AddRecipeView: View {
    let isEditing: Bool

    @EnvironmentObject var userData: DataModel
    @Environment(\.dismiss) var dismiss
    @State private var recipe: RecipeModel = RecipeModel(name: "", category: .grainMix, ingredients: [], note: "")

    @State private var showCameraPicker = false
    @State private var showGalleryPicker = false

    init(recipe: RecipeModel? = nil) {
        if let recipe = recipe {
            self._recipe = State(initialValue: recipe)
            isEditing = true
        } else {
            self._recipe = State(initialValue: RecipeModel(name: "", category: .grainMix, ingredients: [], note: ""))
            isEditing = false
        }
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack (alignment: .leading) {
                    Text("Recipe Name")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white)
                    TextField("Enter recipe name", text: $recipe.name)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .regular))
                        .darkFramed(isBordered: true)
                        .padding(.bottom, 20)
                    Text("Category")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white)
                    HStack {
                        CategoryPickView(category: .grainMix, selectedCategory: $recipe.category)
                        CategoryPickView(category: .mashFeed, selectedCategory: $recipe.category)
                    }
                    HStack {
                        CategoryPickView(category: .proteinSupplement, selectedCategory: $recipe.category)
                        CategoryPickView(category: .vitaminMix, selectedCategory: $recipe.category)
                    }
                    .padding(.bottom, 20)
                    HStack {
                        Text("Ingredients")
                            .font(.system(size: 14, weight: .regular))
                            .foregroundStyle(.white)
                        Spacer()
                        Button {
                            withAnimation {
                                recipe.ingredients.append(IngredientModel(name: "", amount: 0, unit: .kilograms))
                            }
                        } label: {
                            HStack {
                                Image(systemName: "plus")
                                    .foregroundStyle(.yellowAccent)
                                Text("Add Ingredient")
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.yellowAccent)
                            }
                        }
                    }
                    .padding(.bottom, 5)
                    ForEach (Array(recipe.ingredients.enumerated()), id: \.element.id) { index, ingredient in
                        VStack {
                            HStack {
                                TextField("", text: Binding(
                                    get: { recipe.ingredients[index].name },
                                    set: { recipe.ingredients[index].name = $0 }
                                ), prompt: Text("Ingredient Name").foregroundColor(.lightAccent))
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .regular))
                                Button {
                                    withAnimation {
                                        guard index < recipe.ingredients.count else { return }
                                        recipe.ingredients.remove(at: index)
                                    }
                                } label: {
                                    Image(systemName: "trash.fill")
                                        .foregroundColor(.lightAccent)
                                        .font(.system(size: 16, weight: .regular))
                                }
                            }.padding(.bottom, 5)
                            HStack {
                                TextField("", text: Binding(
                                    get: {
                                        recipe.ingredients[index].amount == 0 ? "" : String(format: "%.2f", recipe.ingredients[index].amount)
                                    },
                                    set: { newValue in
                                        let filtered = newValue.filter { $0.isNumber || $0 == "." || $0 == "," }
                                        let normalizedValue = filtered.replacingOccurrences(of: ",", with: ".")
                                        recipe.ingredients[index].amount = Double(normalizedValue) ?? recipe.ingredients[index].amount
                                    }
                                ), prompt: Text("Amount").foregroundColor(.lightAccent))
                                .keyboardType(.decimalPad)
                                .foregroundStyle(.white)
                                .font(.system(size: 16, weight: .regular))
                                .muchDarkFramed(isBordered: true)
                                Picker("Unit", selection: $recipe.ingredients[index].unit) {
                                    ForEach(MeasurementUnit.allCases) { unit in
                                        Text(unit.rawValue)
                                            .foregroundStyle(.white)
                                            .tag(unit)
                                    }
                                }
                                .pickerStyle(.menu)
                                .tint(.white)
                                .padding(10)
                                .background(.backgroundAccent)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(.lightAccent, lineWidth: 1)
                                }
                                .id(recipe.ingredients[index].unit)
                            }
                            .animation(.easeInOut(duration: 0.3), value: recipe.ingredients[index].unit)
                        }
                        .darkFramed(isBordered: true)
                        .padding(.vertical, 3)
                    }
                    Text("Notes (Optional)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white)
                        .padding(.top)
                    TextEditor(text: $recipe.note)
                        .scrollContentBackground(.hidden)
                        .foregroundStyle(.white)
                        .font(.system(size: 16, weight: .regular))
                        .frame(minHeight: 100)
                        .darkFramed()
                        .padding(.bottom)
                    Text("Add Photo (Optional)")
                        .font(.system(size: 14, weight: .regular))
                        .foregroundStyle(.white)
                        .padding(.top)
                    ZStack {
                        Color.backgroundAccent
                        if let imageData = recipe.imageData,
                            let selectedImage = UIImage(data: imageData) {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFill()
                        }
                        VStack {
                            Image(systemName: "camera.fill")
                                .foregroundStyle(.lightAccent)
                            Text("Tap to add a photo of your recipe")
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.lightAccent)
                            HStack {
                                Button {
                                    showCameraPicker = true
                                } label: {
                                    HStack {
                                        Image(systemName: "camera.fill")
                                        Text("Camera")
                                    }
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.white)
                                    .darkFramed(isBordered: true)
                                }
                                Button {
                                    showGalleryPicker = true
                                } label: {
                                    HStack {
                                        Image(systemName: "photo")
                                        Text("Gallery")
                                    }
                                    .font(.system(size: 14, weight: .regular))
                                    .foregroundStyle(.white)
                                    .darkFramed(isBordered: true)
                                }
                            }.padding(.horizontal, 60)
                        }
                    }
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.lightAccent, style: .init(lineWidth: 1, dash: [2,3]))
                    }
                    .padding(.bottom)

                    Button {
                        if isEditing {
                            if let index = userData.recipes.firstIndex(where: { $0.id == recipe.id }) {
                                userData.recipes[index] = recipe
                            }
                        } else {
                            userData.recipes.append(recipe)
                        }
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
                Text(isEditing ? "Edit Recipe" : "Add Recipe")
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
        .sheet(isPresented: $showCameraPicker) {
            ImagePicker(sourceType: .camera, imageData: $recipe.imageData)
        }
        .sheet(isPresented: $showGalleryPicker) {
            ImagePicker(sourceType: .photoLibrary, imageData: $recipe.imageData)
        }
        .background(.backgroundAccent)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder),
                                            to: nil, from: nil, for: nil)
        }
    }
}

struct CategoryPickView: View {
    let category: RecipeCategory
    @Binding var selectedCategory: RecipeCategory

    var body : some View {
        Button {
            withAnimation (.easeInOut(duration: 0.2)) {
                selectedCategory = category
            }
        } label: {
            Text(category.rawValue)
                .font(.system(size: 14, weight: .regular))
                .foregroundStyle(selectedCategory == category ? .black : .white)
                .padding(.horizontal, 20)
                .padding(.vertical, 12)
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(selectedCategory == category ? .yellowAccent : .darkAccent)
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .stroke(.lightAccent, lineWidth: selectedCategory == category ? 0 : 1)
                }
        }
    }
}


#Preview {
    AddRecipeView()
        .environmentObject(DataModel())
        .background(.backgroundAccent)
}
