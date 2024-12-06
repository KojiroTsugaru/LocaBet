//
//  BetDetailsView.swift
//  Stubet
//
//  Created by KJ on 9/5/24.
//

import SwiftUI
import FirebaseFirestore
import MapKit

struct MissionDetailsView: View {
    
    var mission: Mission
    
    @StateObject private var viewModel = MissionDetailsViewModel()
    @State private var showGiveupAlert = false
    
    @Environment(\.presentationMode) var presentationMode
    
    init (mission: Mission) {
        self.mission = mission
    }
    
    var body: some View {
        ZStack {
            VStack {
                // Invite Response Buttons
                if mission.status == .invitePending {
                    HStack(spacing: 8) {
                        // 拒否ボタン
                        Button(
                            action: {
                                // 申請を拒否する処理
                                Task {
                                    await viewModel.rejectMissionRequest(mission: mission)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("拒否する")
                                    .frame(maxWidth: .infinity, maxHeight: 16)
                                    .padding()
                                    .background(Color.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                        
                        // 受けるボタン
                        Button(
                            action: {
                                // 申請を受ける処理
                                Task {
                                    await viewModel.acceptMissionRequest(mission: mission)
                                }
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("受ける")
                                    .frame(maxWidth: .infinity, maxHeight: 16)
                                    .padding()
                                    .background(Color.orange)
                                    .foregroundColor(.white)
                                    .cornerRadius(16)
                            }
                    }
                    .padding()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        // Bet Content Section
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text("ベット内容")
                                    .font(.headline)
                                    .padding(.bottom, 5)
                                
                                Spacer()
                                
                                Text(
                                    mission.status == .ongoing ? "進行中" : "許可待ち"
                                )
                                .font(.subheadline)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(
                                    mission.status == .ongoing ? Color.orange : Color.red
                                )
                                .cornerRadius(10)
                            }
                            
                            HStack {
                                Image(systemName: "person.circle")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                                
                                VStack(alignment: .leading) {
                                    Text("木嶋陸")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                    
                                    Text(mission.title)
                                        .font(.title2)
                                        .fontWeight(.bold)
                                }
                            }
                            
                            Text(mission.description)
                                .font(.body)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                        }
                        .padding()
                        
                        // Location & Time Section
                        VStack(alignment: .leading, spacing: 10) {
                            Text("場所＆時間")
                                .font(.headline)
                                .padding(.bottom, 5)
                            TimeLocationDetailsPanel(betItem: mission)
                        }
                    }
                    .padding()
                    
                }
            }
            if viewModel.isUpdating {
                Color.black.opacity(0.4) // Dimmed background
                    .ignoresSafeArea()

                ProgressView(viewModel.updateMessage)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 10)
            }
        }
        .navigationTitle("ミッション詳細")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Menu(content: {
                Button(
                    action: {
                    // このミッションを諦めるアクション
                        showGiveupAlert = true
                }, label: {
                    Text("諦める")
                        .foregroundColor(.red)
                })
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
            })
        )
        .alert("ミッションを諦めますか？", isPresented: $showGiveupAlert) {
            Button("諦める", role: .destructive) {
                // Action to give up the mission
                Task {
                    await viewModel.giveupMission(mission: mission)
                }
                presentationMode.wrappedValue.dismiss()
            }
            Button("キャンセル", role: .cancel) {
                // Action for cancel (optional)
            }
        } message: {
            Text("この操作は取り消せません。")
        }
    }
}
