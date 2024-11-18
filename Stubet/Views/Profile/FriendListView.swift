//
//  FriendListView.swift
//  Stubet
//
//  Created by KJ on 11/18/24.
//

import SwiftUI

struct FriendListView: View {
    @StateObject private var friendManager = FriendManager.shared
    @State private var isLoading: Bool = false

    var body: some View {
        VStack {
            if isLoading {
                ProgressView("ロード中...")
                    .padding()
            } else {
                if !friendManager.incomingRequests.isEmpty {
                    // Friend Requests Section
                    Section(header: Text("フレンド申請").font(.headline)) {
                        ForEach(friendManager.incomingRequests) { request in
                            HStack {
                                VStack(alignment: .leading) {
                                    Text(request.senderDisplayName)
                                        .font(.headline)
                                    Text("From: \(request.senderName)")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                                Button(
                                    action: {
                                        Task {
                                            do {
                                                try await friendManager
                                                    .acceptFriendRequest(
                                                        requestId: request.id,
                                                        senderId: request.senderId
                                                    )
                                            } catch {
                                                print(
                                                    "Error accepting request: \(error.localizedDescription)"
                                                )
                                            }
                                        }
                                    }) {
                                        Text("承諾する")
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.green)
                                            .cornerRadius(8)
                                    }
                                Button(
                                    action: {
                                        Task {
                                            do {
                                                try await friendManager
                                                    .rejectFriendRequest(
                                                        requestId: request.id
                                                    )
                                            } catch {
                                                print(
                                                    "Error rejecting request: \(error.localizedDescription)"
                                                )
                                            }
                                        }
                                    }) {
                                        Text("拒否する")
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.red)
                                            .cornerRadius(8)
                                    }
                            }
                        }
                    }
                    .padding(.bottom)
                }

                // Friends Section
                if !friendManager.friends.isEmpty {
                    Section(header: Text("フレンド").font(.headline)) {
                        List(friendManager.friends) { friend in
                            HStack {
                                Text(friend.displayName)
                                Spacer()
                                Button(
                                    action: {
                                        friendManager
                                            .removeFriend(
                                                friendId: friend.id
                                            ) { result in
                                                switch result {
                                                case .success:
                                                    print("フレンドを解除しました")
                                                case .failure(let error):
                                                    print(
                                                        "フレンド解除に失敗しました: \(error.localizedDescription)"
                                                    )
                                                }
                                            }
                                    }) {
                                        Text("フレンド解除")
                                            .foregroundColor(.white)
                                            .padding(8)
                                            .background(Color.red)
                                            .cornerRadius(8)
                                    }
                            }
                        }
                    }
                } else {
                    Text("フレンドがいません")
                        .foregroundColor(.gray)
                        .padding()
                }
            }
        }
        .onAppear {
            Task {
                isLoading = true
                defer { isLoading = false }
                do {
                    try await friendManager.fetchFriendRequests()
                    try await friendManager.fetchFriends()
                } catch {
                    print(
                        "Error loading friends or requests: \(error.localizedDescription)"
                    )
                }
            }
        }
    }
}


#Preview {
    FriendListView()
}
