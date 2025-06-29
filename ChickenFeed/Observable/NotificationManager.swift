//
//  NotificationManager.swift
//  ChickenFeed
//
//  Created by Кирилл Архипов on 29.06.2025.
//

import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission(completion: @escaping (Bool) -> Void = { _ in }) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func checkNotificationStatus(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                completion(settings.authorizationStatus == .authorized)
            }
        }
    }
    
    func scheduleFeedingReminder(for feeding: FeedingModel, minutesBefore: Int = 15) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["feeding_\(feeding.id.uuidString)"])
        
        let content = UNMutableNotificationContent()
        content.title = "You have feeding!"
        content.body = "\(feeding.name) in \(minutesBefore) minutes - \(feeding.quantity) \(feeding.quantityUnit.rawValue) \(feeding.type.rawValue)"
        content.sound = .default
        content.userInfo = ["feedingId": feeding.id.uuidString]
        
        let reminderDate = feeding.date.addingTimeInterval(-TimeInterval(minutesBefore * 60))
        
        guard reminderDate > Date() else {
            return
        }
        
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "feeding_\(feeding.id.uuidString)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { _ in }
    }

    func scheduleGeneralChickenFeedingNotification() {
        let content = UNMutableNotificationContent()
        content.title = "🐔 Plan your feeding!"
        content.body = "Don't forget to feed your chickens!"
        content.sound = .default
        content.userInfo = ["type": "general_chicken_feeding"]

        var dateComponents = DateComponents()
        dateComponents.hour = 8
        dateComponents.minute = 0

        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(
            identifier: "general_chicken_feeding",
            content: content,
            trigger: trigger
        )

        UNUserNotificationCenter.current().add(request) { _ in }
    }

    func cancelFeedingReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["feedingReminder"])
    }
    
    func openAppSettings() {
        if let settingsUrl = URL(string: UIApplication.openSettingsURLString),
           UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl)
        }
    }
}
