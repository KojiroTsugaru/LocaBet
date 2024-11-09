//
//  BetManager.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import FirebaseFirestore


class BetMissionManager: ObservableObject {
    
    // create singleton obj
    static let shared = BetMissionManager()
    
    private var db = Firestore.firestore()
    private let currentUserId: String  // Pass the current logged-in user's ID
    
    @Published var allMissions: [Mission] = []
    @Published var allBets: [Bet] = []
    @Published var newMissions: [Mission] = []
    @Published var ongoingMissions: [Mission] = []
    
    @Published var rewardPendingBets: [Bet] = []
    @Published var ongoingBets: [Bet] = []
    
    private init(newMissions: [Mission] = [], ongoingMissions: [Mission] = [],
                 rewardPendingBets: [Bet] = [], ongoingBets: [Bet] = []) {
        // UserProviderからcurrentUserIdを取得
        //        self.currentUserId = UserProvider.shared.getCurrentUserId() ?? "1"
        
        // currentUserIdを手動で設定する
        self.currentUserId = "12345"
        
        if newMissions.isEmpty && ongoingMissions.isEmpty && rewardPendingBets.isEmpty && ongoingBets.isEmpty {
            // Fetch from Firebase only if no dummy data is provided
            fetchBets()
        } else {
            // Use dummy data if provided
            self.newMissions = newMissions
            self.ongoingMissions = ongoingMissions
            self.rewardPendingBets = rewardPendingBets
            self.ongoingBets = ongoingBets
        }
    }
    
    
    // fetch bets
    func fetchBets() {
        db.collection("bets").getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching bets: \(error)")
                return
            }
            
            guard let documents = snapshot?.documents else { return }
            
            for doc in documents {
                let data = doc.data()
                let bet = Bet(id: doc.documentID, data: data)
                
                // If receiverId is matched with current user's id, treat it as Mission
                if bet.receiverId == self.currentUserId {
                    let mission = Mission(from: bet)
                    self.allMissions.append(mission)
                } else {
                    self.allBets.append(bet)
                }
            }
            
            // Assign bets and missions based on status
            // For Bets
            for bet in self.allBets {
                if bet.status == "ongoing" {
                    self.ongoingBets.append(bet)
                } else if bet.status == "rewardPending" {
                    self.rewardPendingBets.append(bet)
                }
            }
            
            // For Missions
            for mission in self.allMissions {
                if mission.status == "ongoing" {
                    self.ongoingMissions.append(mission)
                } else if mission.status == "invitePending" {
                    self.newMissions.append(mission)
                }
            }
        }
        print("on going mission", self.ongoingMissions)
    }
    
    func updateMissionStatus(mission: Mission, newStatus: String) {
        // Find the mission in the ongoingMissions array and update its status
        if let index = ongoingMissions.firstIndex(
            where: { $0.id == mission.id
            }) {
            ongoingMissions[index].status = newStatus
            
            // You can also update the Firestore document if necessary
            db.collection("bets").document(mission.id).updateData([
                "status": newStatus
            ]) { error in
                if let error = error {
                    print("Error updating mission status: \(error)")
                } else {
                    print("Mission status updated successfully")
                }
            }
        }
    }
    
    // craete bet
    func createBet(newBetData: NewBetData) async {
        
        guard let coordinate = newBetData.selectedCoordinates?.coordinate else {
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
            "senderId": currentUserId,
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
