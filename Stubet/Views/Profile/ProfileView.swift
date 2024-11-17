//
//  ProfileView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/06.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var accountManager: AccountManager
    
    var body: some View {
        VStack(spacing: 20) {
            NavigationLink {
                FriendRequestsTest()
            } label: {
                HStack {
                    Image(systemName: "person.fill.badge.plus")
                    Text("フレンド")
                }
                
                .padding()
                .background(Color.orange) // Set background color
                .foregroundColor(.white) // Set text and icon color
                .cornerRadius(8) // Optional: Add rounded corners
            }
                
            if let user = accountManager.currentUser {
                Text(user.userName)
            } else {
                Text("loading user data")
            }
        }
        .navigationTitle("プロフィール")
        .navigationBarTitleDisplayMode(.inline)
            
    }
}
