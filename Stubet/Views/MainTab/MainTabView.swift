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
    @State private var showMissionClearModal = false
    
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
        .accentColor(Color.orange)
        .onChange(of: locationManager.showModalForRegion, { oldValue, newValue in
            if newValue != nil {
                showMissionClearModal = true // Trigger modal display
            }
        })
        .sheet(isPresented: $showMissionClearModal, onDismiss: {
            // Reset the modal trigger after dismissal
            locationManager.showModalForRegion = nil
        }) {
            // Modal Content
            if let regionIdentifier = locationManager.showModalForRegion {
                MissionClearModalView(regionIdentifier: regionIdentifier)
            }
        }
    }
}

#Preview {
    MainTabView()
}
