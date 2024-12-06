//
//  HomeView.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var accountManager = AccountManager.shared
    @StateObject private var betManager = BetManager.shared
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var showNewBetModal = false
    
    enum Tab {
        case mission
        case bet
    }
    
    @State private var selectedTab: Tab = .bet
    
    var body: some View {
        VStack {
            // Tab: ミッション and ベット buttons
            BetMissionTabView(selectedTab: $selectedTab)
            
            // Content depending on the selected tab
            ScrollView {
                if selectedTab == .mission {
                    MissionListView()
                } else {
                    BetListView()
                }
            }.refreshable {
                await betManager.fetchData()
            }
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.bottom)
        .navigationTitle("ホーム")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Button(action: {
                showNewBetModal = true
            }, label: {
                Image(systemName: "plus")
                    .font(.title2)
            })
        )
        .sheet(isPresented: $showNewBetModal, content: {
            CreateBetView(showNewBetModal: $showNewBetModal)
        })
    }
}
