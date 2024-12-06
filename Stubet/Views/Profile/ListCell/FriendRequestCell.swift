//
//  FriendRequestCell.swift
//  Stubet
//
//  Created by KJ on 11/26/24.
//

import SwiftUI

struct FriendRequestCell: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    @StateObject private var friendManager = FriendManager.shared
    let request: FriendRequest
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(request.senderDisplayName)
                    .font(.headline)
                Text("@\(request.senderId)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(
                action: {
                    Task {
                        await accceptRequest()
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("承諾する")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.orange)
                        .cornerRadius(12)
                }
            Button(
                action: {
                    Task {
                        await rejectRequest()
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("拒否する")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .cornerRadius(12)
                }
        }.padding(.horizontal)
    }
    
    fileprivate func accceptRequest() async {
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
    
    fileprivate func rejectRequest() async {
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
}

let dummyRequest: FriendRequest = FriendRequest(
    id: "1",
    data: [
        "senderId": "user123",
        "senderName": "JohnDoe",
        "senderDisplayName": "John Doe",
        "senderIconUrl": "https://example.com/profile/johndoe.jpg",
        "status": "pending",
        "sentAt": Date()
    ]
)

#Preview {
    FriendRequestCell(request: dummyRequest)
}
