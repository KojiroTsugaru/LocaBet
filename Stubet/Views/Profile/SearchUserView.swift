//
//  SearchFriendView.swift
//  Stubet
//
//  Created by KJ on 11/18/24.
//

import SwiftUI
import FirebaseFirestore

struct SearchUserView: View {
    @StateObject private var friendManager = FriendManager.shared
    @StateObject private var accountManager = AccountManager.shared
    @State private var searchText: String = ""
    @State private var searchResults: [Friend] = []
    @State private var isLoading: Bool = false
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""

    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.gray, lineWidth: 0.4)
                    .frame(height: 40)

                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                        .padding(.leading, 8) // Add some padding for the icon
                    TextField("ユーザーを検索...", text: $searchText)
                        .padding(.vertical, 8)
                }
                .padding(.horizontal, 4)
                .onChange(of: searchText) { _, newValue in
                    searchUsers(for: newValue)
                }
            }
            .padding(.horizontal)
            
            Spacer()
            if isLoading {
                ProgressView("検索中...")
            } else if !searchResults.isEmpty {
                // check current user is not icluded in search result
                List(searchResults) { user in
                    HStack {
                        FriendListCell(user: user)
                        Spacer()
                        if !isAlreadyFriend(userId: user.id) {
                            Button(action: {
                                Task {
                                    do {
                                        try await friendManager
                                            .sendFriendRequest(to: user.id)
                                        print("sent friend request to \(user.id)")
                                    } catch {
                                        showErrorMessage(error.localizedDescription)
                                    }
                                }
                            }) {
                                Text("フレンド申請")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                    .padding(8)
                                    .background(Color.orange)
                                    .cornerRadius(12)
                            }
                        } else {
                            Text("フレンド")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                    }
                }
            } else {
                Text("ユーザーが見つかりません")
                    .foregroundColor(.gray)
                    .padding()
            }
            Spacer()
        }
        .alert(isPresented: $showError) {
            Alert(
                title: Text("エラー"),
                message: Text(errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    private func isAlreadyFriend(userId: String) -> Bool {
        return friendManager.friends.contains { $0.id == userId }
    }

    private func searchUsers(for query: String) {
        guard !query.isEmpty else {
            searchResults = []
            return
        }
        
        isLoading = true
        let db = Firestore.firestore()
        guard let currentUserId = accountManager.getCurrentUserId() else {
            showErrorMessage("現在のユーザー情報を取得できませんでした")
            return
        }
        
        var results: [Friend] = []
        var resultIds: [String] = []
        let group = DispatchGroup()

        // Query for userName
        group.enter()
        db.collection("users")
            .whereField("userName", isGreaterThanOrEqualTo: query)
            .whereField("userName", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments {
                snapshot,
                error in
                if let documents = snapshot?.documents {
                    results.append(
                        contentsOf: documents.compactMap { doc in
                            if doc.documentID != currentUserId {
                                resultIds.append(doc.documentID)
                                return Friend(id: doc.documentID, data: doc.data())
                            } else {
                                return nil
                            }
                        })
                }
                group.leave()
            }

        // Query for displayName
        group.enter()
        db.collection("users")
            .whereField("displayName", isGreaterThanOrEqualTo: query)
            .whereField("displayName", isLessThanOrEqualTo: query + "\u{f8ff}")
            .getDocuments {
                snapshot,
                error in
                if let documents = snapshot?.documents {
                    results.append(
                        contentsOf: documents.compactMap { doc in
                            guard doc.documentID != currentUserId else {
                                return nil
                            }
                            if doc.documentID != currentUserId && !resultIds.contains(doc.documentID) {
                                resultIds.append(doc.documentID)
                                return Friend(id: doc.documentID, data: doc.data())
                            } else {
                                return nil
                            }
                        })
                }
                group.leave()
            }

        // Merge results when all queries are done
        group.notify(queue: .main) {
            self.isLoading = false
            self.searchResults = results
        }
    }

    private func showErrorMessage(_ message: String) {
        errorMessage = message
        showError = true
    }
}


#Preview {
    SearchUserView()
}
