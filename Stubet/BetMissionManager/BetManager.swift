//
//  BetManager.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import FirebaseFirestore


class BetManager: ObservableObject {
    
    // create singleton obj
    static let shared = BetManager()
    
    private var db = Firestore.firestore()
    private let currentUserId: String?  // Pass the current logged-in user's ID
    
    @Published var allMissions: [Mission] = []
    @Published var allBets: [Bet] = []
    
    @Published var newMissions: [Mission] = []
    @Published var ongoingMissions: [Mission] = []
    
    @Published var rewardPendingBets: [Bet] = []
    @Published var ongoingBets: [Bet] = []
    @Published var invitePendingBets: [Bet] = []
    
    // Track already fetched document IDs to avoid refetching
    private var fetchedBetIDs: Set<String> = []
    
    init() {
        self.currentUserId = AccountManager.shared.currentUser?.id
    }
    
    
    // fetch bets and mission
    func fetchData() {
        db.collection("bets").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching bets: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for doc in documents {
                
                let docID = doc.documentID
                               
                // Skip if already fetched
                guard !self.fetchedBetIDs.contains(docID) else { continue }
               
                // Mark the document as fetched
                self.fetchedBetIDs.insert(docID)
                
                let data = doc.data()
                let bet = Bet(id: doc.documentID, data: data)
                
                // If receiverId matches current user, treat it as Mission
                if bet.receiverId == self.currentUserId {
                    let mission = Mission(from: bet)
                    self.allMissions.append(mission)
                    
                    // Categorize mission based on status
                    if mission.status == "ongoing" {
                        self.ongoingMissions.append(mission)
                    } else if mission.status == "invitePending" {
                        self.newMissions.append(mission)
                    }
                    
                } else {
                    self.allBets.append(bet)
                    
                    // Categorize bet based on status
                    if bet.status == "ongoing" {
                        self.ongoingBets.append(bet)
                    } else if bet.status == "rewardPending" {
                        self.rewardPendingBets.append(bet)
                    } else if bet.status == "invitePending" {
                        self.invitePendingBets.append(bet)
                    }
                }
            }
        }
        print("on going mission", self.ongoingMissions)
    }
    
    // craete bet
    func createBet(newBetData: NewBetData) async {
        
        guard let coordinate = newBetData.selectedCoordinates else {
            print("No coordinates selected.")
            return
        }
        
        // create location data
        let locationData: [String: Any] = [
            "name": newBetData.locationName,
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
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
            "senderId": currentUserId!,
            "receiverId": newBetData.selectedFriend?.id ?? "0000", // selected friend's id
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
}
