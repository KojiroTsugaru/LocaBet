//
//  BetManager.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import FirebaseFirestore

@MainActor
class BetManager: NSObject, ObservableObject {
    // create singleton obj
    static let shared = BetManager()
    private let db = Firestore.firestore()
    
    @Published var allMissions: [Mission] = []
    @Published var allBets: [Bet] = []
    
    // Missions
    @Published var newMissions: [Mission] = []
    @Published var ongoingMissions: [Mission] = []
    @Published var clearedMissions: [Mission] = []
    @Published var failedMissions: [Mission] = []
    
    // Bets
    @Published var rewardPendingBets: [Bet] = []
    @Published var ongoingBets: [Bet] = []
    @Published var invitePendingBets: [Bet] = []
    @Published var clearedBets: [Bet] = []
    @Published var failedBets: [Bet] = []
    
    // Track already fetched document IDs to avoid refetching
    private var fetchedBetIDs: Set<String> = []
    
    private override init() {
        super.init()
    }
    
    // fetch bets and mission
    func fetchData() async {
        guard let currentUserId = AccountManager.shared.getCurrentUserId() else {
            return
        }
        
        do {
            let snapshot = try await db.collection("bets").getDocuments()
            let documents = snapshot.documents
            
            for doc in documents {
                let docID = doc.documentID
                
                // Skip if already fetched
                guard !self.fetchedBetIDs.contains(docID) else { continue }
                
                // Mark the document as fetched
                self.fetchedBetIDs.insert(docID)
                
                let data = doc.data()
                let bet = Bet(id: docID, data: data)
                
                // determine bet or mission
                if bet.receiverId == currentUserId {
                    let mission = Mission(from: bet)
                    self.allMissions.append(mission)
                    
                    // Categorize mission based on status
                    switch mission.status {
                    case .ongoing:
                        self.ongoingMissions.append(mission)
                    case .invitePending:
                        if await isRequestExpired(betItem: mission) {break}  // check if invite is expired or not
                        self.newMissions.append(mission)
                    case .rewardReceived:
                        self.clearedMissions.append(mission)
                    case .failed:
                        self.failedMissions.append(mission)
                    default:
                        break
                    }
                } else if bet.senderId == currentUserId {
                    self.allBets.append(bet)
                    
                    // Categorize bet based on status
                    switch bet.status {
                    case .ongoing:
                        self.ongoingBets.append(bet)
                    case .rewardPending:
                        self.rewardPendingBets.append(bet)
                    case .invitePending:
                        if await isRequestExpired(betItem: bet) {break}  // check if invite is expired or not
                        self.invitePendingBets.append(bet)
                    case .rewardReceived:
                        self.clearedBets.append(bet)
                    case .failed:
                        self.failedBets.append(bet)
                    default:
                        break
                    }
                }
            }
        } catch {
            print("Error fetching bets: \(error.localizedDescription)")
        }
    }
    
    func refreshData() async {
        self.emptyAllData()
        await self.fetchData()
    }
    
    // craete bet
    func createBet(newBetData: NewBetData) async {
        
        guard let currentUserId = AccountManager.shared.getCurrentUserId() else {
            return
        }
        
        // create location data
        let locationData: [String: Any] = [
            "name": newBetData.locationName,
            "latitude": newBetData.selectedCoordinates.latitude,
            "longitude": newBetData.selectedCoordinates.longitude
        ]
        
        // create bet data
        let data: [String: Any] = [
            "title": newBetData.title,
            "description": newBetData.description,
            "deadline": Timestamp(
                date: newBetData.deadline
            ),
            "createdAt": Timestamp(date: Date()), // The creation date is now
            "updatedAt": Timestamp(
                date: Date()
            ), // Initial value for updatedAt is the same as createdAt
            "senderId": currentUserId,
            "receiverId": newBetData.selectedFriend?.id ?? "" as String, // selected friend's id
            "status": "invitePending", // Default status
            "location": locationData
        ]
        
        // Add a new document in collection "bets"
        do {
            try await db.collection("bets").addDocument(data: data)
            print("Document successfully written!")
            print(data)
        } catch {
            print("Error writing document: \(error)")
        }
    }
    
    // fetch bet by id
    func fetchBetBy(id: String) async -> (any BetItem)? {
        
        guard let currentUserId = AccountManager.shared.getCurrentUserId() else {
            return nil
        }
        
        do {
            
            // get this bet by id
            let document = try await db.collection("bets").document(id).getDocument()
            
            if let data = document.data() {
                let bet = Bet(id: id, data: data)
                
                // check this betItem is bet or missio
                if currentUserId == bet.senderId {
                    return bet
                } else {
                    let mission = Mission(from: bet)
                    return mission
                }
            } else {
                return nil
            }
        } catch {
            print("Error fetching bet: \(error)")
            return nil
        }
    }
    
    // update bet's status
    func updateBetStatus(betItem: any BetItem, newStatus: Status, refreshAfter: Bool = true) async {
        
        // Update the status in Firestore
        do {
            try await db.collection("bets").document(betItem.id).updateData([
                "status": newStatus.rawValue,
                "updatedAt": Timestamp(date: Date())
            ])
            
            // re-fetch all bet data
            if refreshAfter {
                emptyAllData()
                await fetchData()
            }
        } catch {
            print("error updating bet status:", error)
        }
    }
    
    // notify status change
    func notifyStatusUpdateTo(id: String, betId: String, newStatus: Status) async {
        // Example: Using Firestore to send a notification
        let notificationData: [String: Any] = [
            "type": "statusUpdate",
            "betId": betId,
            "newStatus": newStatus.rawValue,
            "timestamp": Timestamp(date: Date())
        ]

        do {
            try await db.collection("users").document(id).collection("notifications").addDocument(data: notificationData)
            print("Notification sent to sender: \(id)")
        } catch {
            print("Error sending notification: \(error)")
        }
    }
    
    func getBetHistory() -> [Bet] {
        let combinedArray = self.failedBets + self.clearedBets
        let sortedArray = combinedArray.sorted { $0.updatedAt.dateValue() > $1.updatedAt.dateValue() }
        return sortedArray
    }
    
    func getMissionHistory() -> [Mission] {
        let combinedArray = self.failedMissions + self.clearedMissions
        let sortedArray = combinedArray.sorted { $0.updatedAt.dateValue() > $1.updatedAt.dateValue() }
        return sortedArray
    }
    
    private func isRequestExpired(betItem: any BetItem) async -> Bool {
        if betItem.deadline.dateValue() < Date() {
            await updateBetStatus(betItem: betItem, newStatus: .inviteExpired, refreshAfter: false)
            return true
        }
        return false
    }
            
    // empty all bets and missions on logout
    func emptyAllData() {
        allMissions = []
        allBets = []
        
        newMissions = []
        ongoingMissions = []
        failedMissions = []
        clearedMissions = []
        
        rewardPendingBets = []
        ongoingBets = []
        invitePendingBets = []
        failedBets = []
        clearedMissions = []
        
        fetchedBetIDs = []
        
        print("all bet/mission data is empty!")
    }
}
