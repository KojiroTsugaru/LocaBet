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
                List {
                    if !friendManager.incomingRequests.isEmpty {
                        Section("フレンド申請が届いています") {
                            ForEach(friendManager.incomingRequests) { request in
                                FriendRequestCell(request: request)
                            }
                        }
                    }
                    if !friendManager.friends.isEmpty {
                        Section("フレンド") {
                            ForEach(friendManager.friends) { friend in
                                FriendCell(friend: friend)
                            }
                        }
                    } else {
                        Section("フレンドがいません") {
                            
                        }
                    }
                }
                
//                if !friendManager.incomingRequests.isEmpty {
//                    // Friend Requests Section
//                    VStack {
//                        Text("フレンド申請が届いています").font(.headline)
//                        List(friendManager.incomingRequests) { request in
//                            FriendRequestCell(request: request)
//                        }.scrollDisabled(true)
//                    }
//                }
//
//                // Friends Section
//                if !friendManager.friends.isEmpty {
//                    List(friendManager.friends) { friend in
//                        FriendCell(friend: friend)
//                    }
//                } else {
//                    Text("フレンドがいません")
//                        .foregroundColor(.gray)
//                        .padding()
//                }
            }
        }
        .navigationTitle("フレンド")
        .task {
            isLoading = true
            defer { isLoading = false }
            do {
                try await friendManager.fetchFriendRequests()
            } catch {
                print(
                    "Error loading friends requests: \(error.localizedDescription)"
                )
            }
        }
    }
}


#Preview {
    FriendListView()
}
