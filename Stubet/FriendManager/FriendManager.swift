//
//  FriendManager.swift
//  Stubet
//
//  Created by KJ on 11/16/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FriendManager: ObservableObject {
    static let shared = FriendManager()
    private let db = Firestore.firestore()
    private let currentUserId = Auth.auth().currentUser?.uid

    // Fetch the list of friends
    @Published var friends: [Friend] = []
    
    func fetchFriends() async throws {
        guard let currentUserId = currentUserId else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])
        }

        let friendsRef = db.collection("users").document(currentUserId).collection("friends")
        
        do {
            // Fetch the documents asynchronously
            let snapshot = try await friendsRef.getDocuments()
            
            // Map the documents to Friend objects
            self.friends = snapshot.documents.compactMap { doc in
                Friend(id: doc.documentID, data: doc.data())
            }
        } catch {
            // Handle any errors that occur during the fetch
            print("Error fetching friends: \(error.localizedDescription)")
            throw error
        }
    }

    func addFriend(byUserName userName: String) async throws {
        guard let currentUserId = currentUserId else {
            throw NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])
        }

        // Query for the user by userName
        let snapshot = try await db.collection("users").whereField("userName", isEqualTo: userName).getDocuments()
        
        guard let document = snapshot.documents.first else {
            throw NSError(domain: "AddFriendError", code: 404, userInfo: [NSLocalizedDescriptionKey: "User not found."])
        }
        
        let friendId = document.documentID
        let data = document.data()
        
        // Prepare friend data
        let friendData: [String: Any] = [
            "userName": data["userName"] ?? "",
            "displayName": data["displayName"] ?? "",
            "addedAt": Timestamp(date: Date()),
            "iconUrl": data["iconUrl"] ?? ""
        ]

        // Add friend to current user's friends subcollection
        try await db.collection("users").document(currentUserId).collection("friends").document(friendId).setData(friendData)
        
        // Optionally, make the relationship mutual
        try await addMutualFriend(currentUserId: currentUserId, friendId: friendId, friendData: friendData)
    }

    private func addMutualFriend(currentUserId: String, friendId: String, friendData: [String: Any]) async throws {
        // Fetch the current user's data
        let currentUserDocument = try await db.collection("users").document(currentUserId).getDocument()
        
        guard let currentUserData = currentUserDocument.data() else {
            throw NSError(domain: "MutualFriendError", code: 404, userInfo: [NSLocalizedDescriptionKey: "Current user data not found."])
        }

        // Prepare current user's data for the mutual relationship
        let currentUserFriendData: [String: Any] = [
            "userName": currentUserData["userName"] ?? "",
            "displayName": currentUserData["displayName"] ?? "",
            "addedAt": Timestamp(date: Date()),
            "icoUrl":currentUserData["iconUrl"] ?? "",
        ]

        // Add current user to the friend's friends subcollection
        try await db.collection("users").document(friendId).collection("friends").document(currentUserId).setData(currentUserFriendData)
    }

    // Remove a friend
    func removeFriend(friendId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let currentUserId = currentUserId else {
            completion(.failure(NSError(domain: "AuthError", code: 401, userInfo: [NSLocalizedDescriptionKey: "User not authenticated."])))
            return
        }

        // Delete friend from the current user's friends subcollection
        db.collection("users").document(currentUserId).collection("friends").document(friendId).delete { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
}
