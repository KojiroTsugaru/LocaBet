//
//  MainTabView.swift
//  Stubet
//
//  Created by KJ on 11/13/24.
//

import SwiftUI

struct MainTabView: View {
    
    @StateObject private var viewModel = MainTabViewModel()
    @StateObject private var locationManager = LocationManager.shared
    @StateObject private var notificationManager = NotificationManager.shared
    
    @State private var showingNotification: BetNotification?
    @State private var selectedTab = 0 // Set HomeView as the default tab
    
    init() {
        // Set tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            // Home tab with NavigationView
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("ホーム")
            }
            .tag(0)

            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("プロフィール")
            }
            .tag(1)
            .onChange(of: notificationManager.betNotifications) { newNotifications in
                if let firstNotification = newNotifications.first {
                    showingNotification = firstNotification
                }
            }
            // sheet for bet notifications
            .sheet(item: $showingNotification) { notification in
                switch notification.type {
                case .missionClear:
                    MissionClearModalView(missionId: notification.betId) {
                        viewModel.dismissNotification(notification)
                    }
                case .missionFail:
                    MissionFailModalView(missionId: notification.betId) {
                        viewModel.dismissNotification(notification)
                    }
                case .betClear:
                    BetClearModalView(betId: notification.betId) {
                        viewModel.dismissNotification(notification)
                    }
                case .betFail:
                    BetFailModalView(betId: notification.betId) {
                        viewModel.dismissNotification(notification)
                    }
                }
            }
        }
        .accentColor(Color.orange)
    }
}

#Preview {
    MainTabView()
}
