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
            Text("My Profile")
                .font(.headline)
            if let user = accountManager.currentUser {
                Text(user.userName)
            } else {
                Text("loading user data")
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("プロフィール")
        .navigationBarTitleDisplayMode(.inline)

    }
}
