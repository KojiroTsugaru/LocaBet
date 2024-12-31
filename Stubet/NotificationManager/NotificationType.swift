//
//  NotificationType.swift
//  Stubet
//
//  Created by KJ on 12/29/24.
//

import Foundation

enum NotificationType {
    case missionClear
    case missionFail
    case betClear
    case betFail
}


extension NotificationType: Equatable {}
