//
//  UserDataModel.swift
//  ProMatch
//
//  Created by Кирилл Архипов on 23.06.2025.
//

import Foundation
import SwiftUI

class DataModel: ObservableObject {
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    @AppStorage("isPushNotificationsOn") var isPushNotifications: Bool = false {
        didSet {
            handlePushNotificationsChange()
        }
    }
    @AppStorage("isFeedingReminderOn") var isFeedingReminderOn: Bool = false {
        didSet {
            handleFeedingReminderChange()
        }
    }

    @Published var feedings: [FeedingModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(feedings), forKey: "feedings")
            CalculatorModel.shared.calculateFeeded(feedings: feedings)
        }
    }
    @Published var recipes: [RecipeModel] {
        didSet {
            UserDefaults.standard.set(try? JSONEncoder().encode(recipes), forKey: "recipes")
        }
    }

    private let notificationManager = NotificationManager.shared

    init() {
        let userDefaults = UserDefaults.standard
        if let data = userDefaults.data(forKey: "feedings"),
           let decoded = try? JSONDecoder().decode([FeedingModel].self, from: data) {
            feedings = decoded
        } else {
            feedings = []
        }
        if let data = userDefaults.data(forKey: "recipes"),
           let decoded = try? JSONDecoder().decode([RecipeModel].self, from: data) {
            recipes = decoded
        } else {
            recipes = []
        }
        checkNotificationPermissions()
    }

    private func handlePushNotificationsChange() {
        if isPushNotifications {
            enablePushNotifications()
        } else {
            disablePushNotifications()
        }
    }

    private func handleFeedingReminderChange() {
        if isFeedingReminderOn {
            enableFeedingReminders()
        } else {
            disableFeedingReminders()
        }
    }

    private func enablePushNotifications() {
        notificationManager.checkNotificationStatus { [weak self] isAuthorized in
            if isAuthorized {
                self?.notificationManager.scheduleGeneralChickenFeedingNotification()
            } else {
                self?.notificationManager.requestPermission { [weak self] granted in
                    DispatchQueue.main.async {
                        if !granted {
                            self?.isPushNotifications = false
                            self?.notificationManager.openAppSettings()
                        }
                    }
                }
            }
        }
    }

    private func disablePushNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        isFeedingReminderOn = false
    }

    private func enableFeedingReminders() {
        if !isPushNotifications {
            isPushNotifications = true
        }
        schedulePendingFeedingReminders()
    }

    private func schedulePendingFeedingReminders() {
        feedings.forEach { feeding in
            notificationManager.scheduleFeedingReminder(for: feeding)
        }
    }

    private func disableFeedingReminders() {
        cancelAllFeedingReminders()
    }

    private func cancelAllFeedingReminders() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            let feedingRequests = requests.filter { $0.identifier.hasPrefix("feeding_") }
            let identifiers = feedingRequests.map { $0.identifier }
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        }
    }

    private func checkNotificationPermissions() {
        notificationManager.checkNotificationStatus { [weak self] isAuthorized in
            DispatchQueue.main.async {
                if !isAuthorized && self?.isPushNotifications == true {
                    self?.isPushNotifications = false
                }
            }
        }
    }

    func reset() {
        isFirstLaunch = true
        isPushNotifications = false
        isFeedingReminderOn = false
        feedings = []
        recipes = []
    }
}
