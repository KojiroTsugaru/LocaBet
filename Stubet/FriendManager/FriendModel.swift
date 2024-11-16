//
//  FriendModel.swift
//  Stubet
//
//  Created by KJ on 9/4/24.
//

import Foundation
import FirebaseFirestore

struct Friend: Identifiable {
    let id: String
    let userName: String
    let displayName: String
    let addedAt: Date
    var iconUrl: String         // URL of the user's icon

    init(id: String, data: [String: Any]) {
        self.id = id
        self.userName = data["userName"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? ""
        self.addedAt = (data["addedAt"] as? Timestamp)?.dateValue() ?? Date()
        self.iconUrl = data["iconUrl"] as? String ?? ""
    }
}

