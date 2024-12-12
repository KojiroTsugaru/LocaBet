//
//  MissionModel.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import Foundation
import FirebaseFirestore

struct Mission: BetItem {
    let id: String
    let title: String
    let description: String
    let deadline: Timestamp
    let createdAt: Timestamp
    let updatedAt: Timestamp
    let location: Location
    let senderId: String
    var status: Status

    init(from bet: Bet) {
        self.id = bet.id
        self.title = bet.title
        self.description = bet.description
        self.deadline = bet.deadline
        self.createdAt = bet.createdAt
        self.updatedAt = bet.updatedAt
        self.location = bet.location
        self.senderId = bet.senderId
        self.status = bet.status
    }
}
