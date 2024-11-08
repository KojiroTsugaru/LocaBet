//
//  HomeView.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import SwiftUI
import FirebaseFirestore

struct HomeView: View {
    @State private var navigationPath = NavigationPath()
    
    @ObservedObject var viewModel: HomeViewModel
    
    let betManager = BetMissionManager.shared
    
    // Use the locationManager as an EnvironmentObject
    @EnvironmentObject var locationManager: UserLocationManager
    
    @State private var showingClearModal = false
    
    // Track the nearest mission location to the user gets close to
    @State private var nearestMission: Mission?
    
    @State private var bets: [Bet] = []
    @State private var showModal: Bool = false
    @State private var changedBet: Bet? // Track which bet changed
    
    private var db = Firestore.firestore()
    private var listener: ListenerRegistration?
    
    @State private var showNewBet = false
    
    @State var showModalAfter40 = false
    
    init() {
        self.viewModel = HomeViewModel()
    }
    
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            VStack {
                // Tab Switching: ミッション and ベット buttons
                HStack {
                    Spacer()
                    Button(action: {
                        viewModel.selectedTab = .mission
                    }) {
                        Text("ミッション")
                            .font(.system(size: 12))
                            .padding(10)
                            .background(viewModel.selectedTab == .mission ? Color.orange : Color.clear)
                            .foregroundColor(viewModel.selectedTab == .mission ? .white : .gray)
                            .cornerRadius(48)
                    }
                    Spacer()
                    Button(action: {
                        viewModel.selectedTab = .bet
                    }) {
                        Text("ベット")
                            .font(.system(size: 12))
                            .padding(10)
                            .background(viewModel.selectedTab == .bet ? Color.orange : Color.clear)
                            .foregroundColor(viewModel.selectedTab == .bet ? .white : .gray)
                            .cornerRadius(48)
                    }
                    Spacer()
                }
                .padding(.bottom)
                
                // Content depending on the selected tab
                ScrollView {
                    if viewModel.selectedTab == .mission {
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
                    showNewBet = true
                }, label: {
                    Image(systemName: "plus")
                        .font(.title2)
                })
            )
            .sheet(isPresented: $showNewBet, content: {
                CreateBetView(showNewBet: $showNewBet, showingClearModal: $showingClearModal)
            })
            
            
            //自分がミッションクリアモーダル
            .sheet(isPresented: $showingClearModal) {
                // The modal content
                VStack(spacing: 10) {
                    Text("ミッションをクリアしました!")
                        .font(.title)
                        .padding()
                    Text("ミッション アーク森ビル!")
                    Button("閉じる") {
                        showingClearModal = false
                    }
                }.background(Color.orange)
            }
        }.accentColor(.orange)
        //            ミッションをクリアされた場合のモーダル
            .sheet(isPresented: $showModal) {
                if let changedBet = changedBet {
                    VStack {
                        Text("Status Changed!")
                            .font(.largeTitle)
                        Text("Bet: \(changedBet.title)")
                        Text("New Status: \(changedBet.status)")
                        Button("Dismiss") {
                            showModal = false
                        }
                    }
                }
            }.accentColor(.orange)
}

    // MARK: - Mission Section
var missionSection: some View {
    VStack(alignment: .leading, spacing: 20) {
        if betManager.newMissions.count > 0 {
            Text("新しいミッションが届いています")
                .font(.headline)
                .padding(.leading)
            
            ForEach(betManager.newMissions) { mission in
                NavigationLink(destination: MissionDetailsView(mission: mission)) {
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
                NavigationLink(destination: MissionDetailsView(mission: mission)) {
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

// Function to listen to the bets collection in Firestore
//        private func listenToBetCollection() {
//            listener = db.collection("bets").addSnapshotListener { snapshot, error in
//                guard let snapshot = snapshot else {
//                    print("Error fetching snapshot: \(error!)")
//                    return
//                }
//
//                var updatedBets: [Bet] = []
//
//                snapshot.documentChanges.forEach { diff in
//                    let data = diff.document.data()
//                    let betId = diff.document.documentID
//                    let bet = Bet(id: betId, data: data)
//
//                    // Check if the change is a modification and if the status field changed
//                    if diff.type == .modified {
//                        if let index = bets.firstIndex(where: { $0.id == betId }) {
//                            let previousBet = bets[index]
//                            if previousBet.status != bet.status {
//                                // Show modal if status has changed
//                                changedBet = bet
//                                showModal = true
//                            }
//                        }
//                    }
//
//                    // Update the bet list regardless of the change type
//                    updatedBets.append(bet)
//                }
//
//                // Update the local bets list
//                bets = updatedBets
//            }
//        }
}
