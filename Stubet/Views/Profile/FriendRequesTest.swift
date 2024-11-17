//
//  FriendRequesTest.swift
//  Stubet
//
//  Created by KJ on 11/17/24.
//
import SwiftUI

struct FriendRequestsTest: View {
    @ObservedObject var friendManager = FriendManager.shared
    @State private var errorMessage: String? // To handle errors gracefully
    @State private var isLoading: Bool = false // Show loading indicator during tasks

    var body: some View {
        VStack {
            if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            if isLoading {
                ProgressView("Loading requests...")
                    .padding()
            } else {
                List(friendManager.incomingRequests) { request in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(request.senderDisplayName)
                                .font(.headline)
                            Text(request.senderName)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                        Spacer()

                        // Accept button
                        Button("Accept") {
                            handleAccept(request: request)
                        }
                        .buttonStyle(.bordered)

                        // Reject button
                        Button("Reject") {
                            handleReject(request: request)
                        }
                        .buttonStyle(.bordered)
                        .foregroundColor(.red)
                    }
                }
            }
        }
        .onAppear {
            loadFriendRequests()
        }
        .navigationTitle("Friend Requests")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Actions

    private func loadFriendRequests() {
        isLoading = true
        Task {
            do {
                try await friendManager.fetchFriendRequests()
            } catch {
                errorMessage = error.localizedDescription
            }
            isLoading = false
        }
    }

    private func handleAccept(request: FriendRequest) {
        Task {
            do {
                try await friendManager.acceptFriendRequest(requestId: request.id, senderId: request.senderId)
                await MainActor.run {
                    // Update UI after accepting
                    friendManager.incomingRequests.removeAll { $0.id == request.id }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error accepting request: \(error.localizedDescription)"
                }
            }
        }
    }

    private func handleReject(request: FriendRequest) {
        Task {
            do {
                try await friendManager.rejectFriendRequest(requestId: request.id)
                await MainActor.run {
                    // Update UI after rejecting
                    friendManager.incomingRequests.removeAll { $0.id == request.id }
                }
            } catch {
                await MainActor.run {
                    errorMessage = "Error rejecting request: \(error.localizedDescription)"
                }
            }
        }
    }
}


#Preview {
    FriendRequestsTest()
}

