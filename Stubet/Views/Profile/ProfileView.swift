//
//  ProfileView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/06.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var accountManager: AccountManager
    @StateObject private var friendManager = FriendManager.shared
    
    @State private var selectedTab: Tab = .mission // Track the selected tab

    enum Tab {
        case mission
        case bet
    }
    
    var body: some View {
        VStack() {
            ProfileViewHeader()
            HStack {
                Text("過去のベット/ミッション")
                    .padding(.horizontal)
                    .bold()
                Spacer()
            }
            
            ProfileTabView(selectedTab: $selectedTab)
                .frame(height: 25)
                .padding()
            
            // Content depending on the selected tab
            ScrollView {
                if selectedTab == .mission {
                    MissionHistoryListView()
                } else {
                    BetHistoryListView()
                }
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline) // No visible title
        .task {
            do {
                try await friendManager.fetchFriends()
            } catch {
                print(
                    "Error loading friends: \(error.localizedDescription)"
                )
            }
        }
    }
            
}


#Preview {
    ProfileView()
        .environmentObject(AccountManager.shared)
}
