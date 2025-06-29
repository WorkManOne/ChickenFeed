//
//  FeedingView.swift
//  ChickenRoad
//
//  Created by Кирилл Архипов on 27.06.2025.
//

import SwiftUI

struct FeedingView: View {
    @EnvironmentObject var userData: DataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack {
            let groupedFeedings = Dictionary(grouping: userData.feedings) { feeding in
                Calendar.current.startOfDay(for: feeding.date)
            }
            let sortedFeedings = groupedFeedings.sorted { $0.key > $1.key }
            ScrollView {
                LazyVStack(spacing: 10) {
                    ForEach(sortedFeedings, id: \.key) { date, feedings in
                        VStack(alignment: .leading, spacing: 10) {
                            Text(date.formatted(date: .abbreviated, time: .omitted))
                                .font(.system(size: 14, weight: .regular))
                                .foregroundStyle(.white)
                            ForEach(feedings) { feeding in
                                FeedingPreView(feeding: feeding)
                                    .contextMenu {
                                        NavigationLink {
                                            AddFeedingView(feeding: feeding)
                                        } label: {
                                            Text("Edit")
                                        }
                                        Button {
                                            withAnimation {
                                                if let index = userData.feedings.firstIndex(where: { $0.id == feeding.id } ) {
                                                    userData.feedings.remove(at: index)
                                                }
                                            }
                                        } label: {
                                            Text("Delete")
                                        }
                                    }
                            }
                        }
                        .padding(.vertical)
                    }
                }
                .padding(.horizontal, 20)
            }
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    NavigationLink {
                        AddFeedingView()
                    } label: {
                        Image(systemName: "plus")
                            .font(.system(size: 25))
                            .foregroundStyle(.black)
                            .padding(20)
                            .background(
                                Circle()
                                    .fill(.yellowAccent)
                            )
                            .padding(20)
                    }
                }
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
                Text("Feeding Diary")
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
    }

}

#Preview {
    FeedingView()
        .environmentObject(DataModel())
        .background(.backgroundAccent)
        //.ignoresSafeArea()
}
