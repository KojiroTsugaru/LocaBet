//
//  MissionModel.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import Foundation
import FirebaseFirestore

struct Mission: Identifiable {
    let id: String
    let title: String
    let description: String
    let deadline: Timestamp
    let location: Location
    let senderId: String
    var status: String

    init(from bet: Bet) {
        self.id = bet.id
        self.title = bet.title
        self.description = bet.description
        self.deadline = bet.deadline
        self.location = bet.location
        self.senderId = bet.senderId
        self.status = bet.status
    }
    
    // Computed property for formatted deadline
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
