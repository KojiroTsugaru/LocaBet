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
                ScrollView {
                    VStack {
                        if !friendManager.incomingRequests.isEmpty {
                            // Friend Requests Section
                            VStack(alignment: .leading) {
                                Text("フレンド申請が届いています")
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.horizontal)
                                ForEach(friendManager.incomingRequests) { request in
                                    FriendRequestCell(request: request)
                                    Divider()
                                        .padding(.horizontal)

                                }
                            }
                        }
                        
                        // Friends Section
                        if !friendManager.friends.isEmpty {
                            VStack(alignment: .leading) {
                                Text("フレンド")
                                    .font(.subheadline)
                                    .bold()
                                    .padding(.horizontal)
                                ForEach(friendManager.friends) { friend in
                                    FriendCell(friend: friend)
                                    Divider()
                                        .padding(.horizontal)
                                }
                            }
                        } else {
                            VStack(alignment: .center) {
                                Text("フレンドがいません")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .padding()
                            }
                        }
                    }
                }
                
//                List {
//                    Section(header: Text("フレンド申請が届いています")) {
//                        ForEach(friendManager.incomingRequests) { request in
//                            FriendRequestCell(request: request)
//                        }
//                    }
//
//                    Section(header: Text("フレンド")) {
//                        ForEach(friendManager.friends) { friend in
//                            FriendCell(friend: friend)
//                        }
//                    }
//                }
//                .listStyle(.insetGrouped) // Adjust the list style as needed
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
