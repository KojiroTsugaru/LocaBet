//
//  HomeView.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var accountManager: AccountManager
    @StateObject private var betManager = BetManager.shared
    @StateObject private var locationManager = LocationManager.shared
    
    @State private var navigationPath = NavigationPath()
    
    @State private var showNewBetModal = false
    @State private var showMissionClearModal = false
    
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
            .onChange(
                of: locationManager.showModalForRegion, perform: { regionIdentifier in
                    if regionIdentifier != nil {
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
            .task {
                do {
                    try await accountManager.fetchCurrentUser()
                    betManager.fetchData()
                } catch {
                    print(error)
                }
            }
             
        }
}
