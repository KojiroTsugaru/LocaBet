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
        }
        // sheet for bet notifications
        .sheet(item: $viewModel.currentNotification) { notification in
            switch notification.type {
            case .missionClear:
                MissionClearModalView(missionId: notification.id) {
                    viewModel.currentNotification = nil // Dismiss modal
                    viewModel.showNextNotification()
                }
            case .missionFail:
                MissionFailModalView(missionId: notification.id) {
                    viewModel.currentNotification = nil // Dismiss modal
                    viewModel.showNextNotification()
                }
            case .betClear:
                BetClearModalView(betId: notification.id) {
                    viewModel.currentNotification = nil // Dismiss modal
                    viewModel.showNextNotification()
                }
            case .betFail:
                BetFailModalView(betId: notification.id) {
                    viewModel.currentNotification = nil // Dismiss modal
                    viewModel.showNextNotification()
                }
            }
        }
        .accentColor(Color.orange)
    }
}

#Preview {
    MainTabView()
}
