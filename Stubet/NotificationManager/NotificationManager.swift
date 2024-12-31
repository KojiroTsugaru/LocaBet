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
                    if let type = data["type"] as? String,
                       let newStatus = data["newStatus"] as? String,
                       let betId = data["betId"] as? String,
                       type == "statusUpdate" {
                        
                        // bet was failed
                        if newStatus == Status.failed.rawValue {
                            // add it to notification for modal
                            self.betNotifications.append(BetNotification(id: betId, type: .betFail))
                        }
                        // bet was cleared
                        else if newStatus == Status.rewardPending.rawValue {
                            self.betNotifications.append(BetNotification(id: betId, type: .betClear))
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
    func notifyStatusUpdateFor(id: String, betId: String, newStatus: Status) async {
        // Example: Using Firestore to send a notification
        let notificationData: [String: Any] = [
            "type": "statusUpdate",
            "betId": betId,
            "newStatus": newStatus.rawValue,
            "timestamp": Timestamp(date: Date())
        ]

        do {
            // create notitfication with betId as unique id
            try await db.collection("users").document(id).collection("notifications").document(betId).setData(notificationData)
            
            print("Sent Notificaation with id: \(betId)")
            print("Notification sent to sender: \(id)")
        } catch {
            print("Error sending notification: \(error)")
        }
    }
    
    func deleteNotification(notification: BetNotification){
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
