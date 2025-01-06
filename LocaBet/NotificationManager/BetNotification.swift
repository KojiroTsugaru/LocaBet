//
//  BetNotification.swift
//  Stubet
//
//  Created by KJ on 12/29/24.
//

import Foundation

struct BetNotification: Identifiable, Equatable {
    let id: String
    let betId: String
    let type: NotificationType
    
    init(id: String, betId: String, type: NotificationType) {
        self.id = id
        self.betId = betId
        self.type = type
    }
}
