//
//  FriendRequestModel.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/05.
//

import Foundation
import FirebaseFirestore

struct FriendRequest: Identifiable {
    let id: String
    let senderId: String
    let senderName: String
    let senderDisplayName: String
    let senderIconUrl: String
    let status: String
    let sentAt: Timestamp

    init(id: String, data: [String: Any]) {
        self.id = id
        self.senderId = data["senderId"] as? String ?? ""
        self.senderName = data["senderName"] as? String ?? ""
        self.senderDisplayName = data["senderDisplayName"] as? String ?? ""
        self.senderIconUrl = data["senderIconUrl"] as? String ?? ""
        self.status = data["status"] as? String ?? "pending"
        self.sentAt = data["sentAt"] as? Timestamp ?? Timestamp(date: Date())
    }
}


