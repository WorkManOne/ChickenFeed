//
//  SettingsView.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 23.06.2025.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userData: DataModel
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack (alignment: .leading, spacing: 15) {
            HStack {
                Image("bell")
                Text("Notification Settings")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.vertical, 10)
            }
            VStack {
                HStack {
                    VStack (alignment: .leading) {
                        Text("Push Notifications")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.bottom, 1)
                        Text("Receive alerts on your device")
                            .foregroundStyle(.lightAccent)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                    Toggle(isOn: $userData.isPushNotifications, label: {})
                        .toggleStyle(CustomToggleStyle())
                }
                Rectangle()
                    .frame(height: 1)
                    .padding(.vertical)
                    .padding(.horizontal, -16)
                    .foregroundStyle(.lightAccent.opacity(0.3))

                HStack {
                    VStack (alignment: .leading) {
                        Text("Feeding Reminders")
                            .foregroundStyle(.white)
                            .font(.system(size: 16, weight: .medium))
                            .padding(.bottom, 1)
                        Text("Daily feeding time alerts")
                            .foregroundStyle(.lightAccent)
                            .font(.system(size: 12, weight: .medium))
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .layoutPriority(1)
                    Toggle(isOn: $userData.isFeedingReminderOn, label: {})
                        .toggleStyle(CustomToggleStyle())
                }
            }
            .darkFramed()
            .padding(.bottom)
            HStack {
                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                    .foregroundStyle(.yellowAccent)
                Text("Reset Options")
                    .foregroundStyle(.white)
                    .font(.system(size: 18, weight: .bold))
                    .padding(.vertical, 10)
            }
            Button {
                userData.reset()
            } label: {
                VStack (alignment: .leading) {
                    Text("Factory Reset")
                        .font(.system(size: 16, weight: .medium))
                        .padding(.bottom, 1)
                        .foregroundStyle(.red)
                    Text("Restore app to default settings")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.lightAccent)
                }.frame(maxWidth: .infinity, alignment: .leading)

                .darkFramed()
            }
            Spacer()
        }.padding(.horizontal, 20)
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
                    Text("Settings")
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
    SettingsView()
        .environmentObject(DataModel())
        .background(.backgroundAccent)
}


#Preview {
    NavigationStack {
        NavigationLink("Settings") {
            SettingsView()
                .environmentObject(DataModel())
                .background(.backgroundAccent)
        }
    }
}
