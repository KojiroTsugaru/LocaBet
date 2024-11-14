//
//  HomeView.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import SwiftUI
import FirebaseFirestore

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
        NavigationStack(path: $navigationPath) {
            VStack {
                // Tab Switching: ミッション and ベット buttons
                HStack {
                    Spacer()
                    Button(action: {
                        selectedTab = .mission
                    }) {
                        Text("ミッション")
                            .font(.system(size: 12))
                            .padding(10)
                            .background(
                                selectedTab == .mission ? Color.orange : Color.clear
                            )
                            .foregroundColor(
                                selectedTab == .mission ? .white : .gray
                            )
                            .cornerRadius(48)
                    }
                    Spacer()
                    Button(action: {
                        selectedTab = .bet
                    }) {
                        Text("ベット")
                            .font(.system(size: 12))
                            .padding(10)
                            .background(
                                selectedTab == .bet ? Color.orange : Color.clear
                            )
                            .foregroundColor(
                                selectedTab == .bet ? .white : .gray
                            )
                            .cornerRadius(48)
                    }
                    Spacer()
                }
                .padding(.bottom)
                
                // Content depending on the selected tab
                ScrollView {
                    if selectedTab == .mission {
                        missionSection
                    } else {
                        betSection
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
                } catch {
                    print(error)
                }
                
                betManager.fetchData()
            }
             
        }
    }

    // MARK: - Mission Section
    var missionSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if betManager.newMissions.count > 0 {
                Text("新しいミッションが届いています")
                    .font(.headline)
                    .padding(.leading)
            
                ForEach(betManager.newMissions) { mission in
                    NavigationLink(
                        destination: MissionDetailsView(mission: mission)
                    ) {
                        MissionRowView(mission: mission, isNew: true)
                    }
                    .padding(.horizontal)
                }
            }
        
            if betManager.ongoingMissions.count > 0 {
                Text("進行中のミッション")
                    .font(.headline)
                    .padding(.leading)
            
                ForEach(betManager.ongoingMissions) { mission in
                    NavigationLink(
                        destination: MissionDetailsView(mission: mission)
                    ) {
                        MissionRowView(mission: mission, isNew: false)
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("進行中のミッションはありません")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: 250)
            }
        }
    }

    // MARK: - Bet Section
    var betSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if betManager.rewardPendingBets.count > 0 {
                Text("報酬を受け取っていません！")
                    .font(.headline)
                    .padding(.leading)
            
                ForEach(betManager.rewardPendingBets) { bet in
                    NavigationLink(destination: BetDetailsView(bet: bet)) {
                        BetRowView(bet: bet, isNew: true)
                    }
                    .padding(.horizontal)
                }
            }
        
            if betManager.ongoingBets.count > 0 {
                Text("進行中のベット")
                    .font(.headline)
                    .padding(.leading)
            
                ForEach(betManager.ongoingBets) { bet in
                    NavigationLink(destination: BetDetailsView(bet: bet)) {
                        BetRowView(bet: bet, isNew: false)
                    }
                    .padding(.horizontal)
                }
            } else {
                Text("進行中ベットはありません")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: 250)
            }
        }
    }
}
