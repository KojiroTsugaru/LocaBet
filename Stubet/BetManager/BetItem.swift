//
//  BetItem.swift
//  Stubet
//
//  Created by KJ on 12/6/24.
//

import Foundation
import FirebaseFirestore

protocol BetItem: Identifiable {
    var id: String { get }
    var title: String { get }
    var description: String { get }
    var deadline: Timestamp { get }
    var location: Location { get }
    var senderId: String { get }
    var status: Status { get set }
    var formattedDeadline: String { get }
    var deadlineTimeRemaining: String { get }
}

enum Status: String {
    case invitePending = "invitePending"
    case inviteRejected = "inviteRejected"
    case inviteExpired = "inviteExpired"
    case ongoing = "ongoing"
    case rewardReceived = "rewardReceived"
    case rewardPending = "rewardPending"
    case failed = "failed"
}

extension BetItem {
    // Default implementation for `formattedDeadline`
    var formattedDeadline: String {
        let dateFormatter = DateFormatter()
        
        // Format the date
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let dateString = dateFormatter.string(from: deadline.dateValue())
        
        // Format the time
        dateFormatter.dateFormat = "h:mm a"
        let timeString = dateFormatter.string(from: deadline.dateValue())
        
        return "\(dateString) - \(timeString)"
    }
    
    // Default implementation for `deadlineTimeRemaining`
    var deadlineTimeRemaining: String {
        // Convert deadline property in Timestamp to a Date
        let targetDate = deadline.dateValue()
        
        // Get the time interval in seconds
        let timeInterval = targetDate.timeIntervalSinceNow
        
        // If timeInterval is negative, the target time is in the past
        guard timeInterval > 0 else {
            return "期限を過ぎています"
        }
        
        // Calculate days, hours, and minutes
        let minutes = Int(timeInterval / 60) % 60
        let hours = Int(timeInterval / 3600) % 24
        let days = Int(timeInterval / (3600 * 24))
        
        // Determine the appropriate format
        if days > 0 {
            return "\(days) day\(days > 1 ? "s" : "") left"
        } else if hours > 0 {
            return "\(hours) hour\(hours > 1 ? "s" : "") left"
        } else {
            return "\(minutes) minute\(minutes > 1 ? "s" : "") left"
        }
    }
}
