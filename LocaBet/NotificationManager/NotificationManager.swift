//
//  NotificationManager.swift
//  Stubet
//
//  Created by KJ on 12/31/24.
//

import Foundation
import Firebase

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    private var notificationListener: ListenerRegistration?
    private let db = Firestore.firestore()
    
    @Published var betNotifications: [BetNotification] = []

    func startListeningForNotifications(for userId: String) {
        // リスナーを既に登録済みの場合は解除
        notificationListener?.remove()
        
        // 新しいリスナーを登録
        notificationListener = db
            .collection("users")
            .document(userId)
            .collection("notifications")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { snapshot, error in
                if let error = error {
                    print("Error fetching notifications: \(error)")
                    return
                }
                // 通知処理
                guard let documents = snapshot?.documents else { return }
                for document in documents {
                    let data = document.data()
                    let id = document.documentID
                    if let type = data["type"] as? String,
                       let betId = data["betId"] as? String {
                        
                        // bet was failed
                        if type == NotificationType.missionFail.rawValue {
                            // add it to notification for modal
                            self.betNotifications.append(BetNotification(id: id, betId: betId, type: .betFail))
                        }
                        // bet was cleared
                        else if type == NotificationType.missionClear.rawValue {
                            self.betNotifications.append(BetNotification(id: id, betId: betId, type: .betClear))
                        }
                    }
                }
            }
    }

    func stopListening() {
        notificationListener?.remove()
        notificationListener = nil
    }
    
    // notify status change
    @MainActor
    func notifyStatusUpdateFor(id: String, betId: String, notificationType: NotificationType) async {
        // Example: Using Firestore to send a notification
        let notificationData: [String: Any] = [
            "type": notificationType.rawValue,
            "betId": betId,
            "timestamp": Timestamp(date: Date())
        ]

        do {
            let notificationId = UUID().uuidString
            // create notitfication with unique UUID
            try await db.collection("users").document(id).collection("notifications").document(notificationId).setData(notificationData)
            
            // add a notification to myself
            self.betNotifications.append(BetNotification(id: notificationId, betId: betId, type: notificationType))
            
            print("Sent Notification with automatically generated ID")
            print("Notification sent to sender: \(id)")
        } catch {
            print("Error sending notification: \(error)")
        }
    }
    
    func deleteNotification(notification: BetNotification) {
        guard let currentUserId = AccountManager.shared.getCurrentUserId() else {
            return
        }
        
        print("trying to remove notification: \(notification.id)")
        // Remove notification from Firestore
        db.collection("users")
            .document(currentUserId)
            .collection("notifications")
            .document(notification.id)
            .delete { error in
                if let error = error {
                    print("Error removing notification: \(error)")
                } else {
                    print("Notification successfully removed from Firestore.")
                }
            }
    }
    
}
