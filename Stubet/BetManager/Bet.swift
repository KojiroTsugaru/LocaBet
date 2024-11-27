//
//  BetModel.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import Foundation
import FirebaseFirestore

struct Bet: Identifiable {
    let id: String           // betId (document ID or UUID)
    let title: String        // Title of the bet
    let description: String  // Description of the bet
    let deadline: Timestamp  // Deadline for the bet (Firestore Timestamp)
    let createdAt: Timestamp // Timestamp when the bet was created
    let updatedAt: Timestamp // Timestamp when the bet was last updated
    let senderId: String     // User ID of the person who created the bet
    let receiverId: String   // User ID of the person who receives the bet
    let location: Location   // Location object (nested)
    
    var status: String       // invitePending, inviteRejected, inviteExpired, ongoing, rewardReceived, rewardPending, failed

    // Initialize from Firebase document data
    init(id: String, data: [String: Any]) {
        self.id = id
        self.title = data["title"] as? String ?? ""
        self.description = data["description"] as? String ?? ""
        self.deadline = data["deadline"] as? Timestamp ?? Timestamp(date: Date())
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
        self.updatedAt = data["updatedAt"] as? Timestamp ?? Timestamp(date: Date())
        self.senderId = data["senderId"] as? String ?? ""
        self.receiverId = data["receiverId"] as? String ?? ""
        self.status = data["status"] as? String ?? "pending"
        
        if let locationData = data["location"] as? [String: Any] {
            self.location = Location(data: locationData)
        } else {
            // Default location if none provided
            self.location = Location(data: [
                "name": "",
                "address": "",
                "latitude": 0.0,
                "longitude": 0.0
            ])
        }
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
