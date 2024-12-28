//
//  BetNotification.swift
//  Stubet
//
//  Created by KJ on 12/29/24.
//

import Foundation

struct BetNotification: Identifiable {
    let id: String // Use betId as the unique identifier
    let type: NotificationType
    
    init(id: String, type: NotificationType) {
        self.id = id
        self.type = type
    }
}
