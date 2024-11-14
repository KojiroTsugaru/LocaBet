//
//  MainTabView.swift
//  Stubet
//
//  Created by KJ on 11/13/24.
//

import SwiftUI

struct MainTabView: View {
    
    @State private var selectedTab = 0 // Set HomeView as the default tab
    @ObservedObject var accoutManager = AccountManager.shared
    
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
        .environmentObject(accoutManager) // Inject the singleton into the environment
    }
}

#Preview {
    MainTabView()
}
