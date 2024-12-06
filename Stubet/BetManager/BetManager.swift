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
    
    @Published var newMissions: [Mission] = []
    @Published var ongoingMissions: [Mission] = []
    
    @Published var rewardPendingBets: [Bet] = []
    @Published var ongoingBets: [Bet] = []
    @Published var invitePendingBets: [Bet] = []
    
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
                        self.newMissions.append(mission)
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
                        self.invitePendingBets.append(bet)
                    default:
                        break
                    }
                }
            }
        } catch {
            print("Error fetching bets: \(error.localizedDescription)")
        }
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
                date: newBetData.date
            ), // Use the date as the deadline
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
    
    // update bet's status
    func updateBetStatus(betItem: any BetItem, newStatus: Status) async {
        // Assume you have a reference to the Firestore database
        let db = Firestore.firestore()
        
        // Update the status in Firestore
        do {
            try await db.collection("bets").document(betItem.id).updateData([
                "status": newStatus.rawValue,
                "updatedAt": Timestamp(date: Date())
            ])
            
            // re-fetch all bet data
            emptyAllData()
            await fetchData()
        } catch {
            print("error updating bet status:", error)
        }
    }
    
    // empty all bets and missions on logout
    func emptyAllData() {
        allMissions = []
        allBets = []
        
        newMissions = []
        ongoingMissions = []
        
        rewardPendingBets = []
        ongoingBets = []
        invitePendingBets = []
        
        fetchedBetIDs = []
        
        print("all bet/mission data is empty!")
    }
}
