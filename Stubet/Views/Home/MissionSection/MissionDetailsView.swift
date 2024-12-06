//
//  BetDetailsView.swift
//  Stubet
//
//  Created by KJ on 9/5/24.
//

import SwiftUI
import FirebaseFirestore

struct MissionDetailsView: View {
    
    let mission: Mission
    
    init (mission: Mission) {
        self.mission = mission
    }
    
    var body: some View {
        VStack {
            // Invite Response Buttons
            if mission.status == .invitePending {
                HStack(spacing: 8) {
                    // 拒否ボタン
                    Button(action: {
                        // 申請を拒否する処理
                    }) {
                        Text("拒否する")
                            .frame(maxWidth: .infinity, maxHeight: 16)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(16)
                    }
                    
                    // 受けるボタン
                    Button(action: {
                        // 申請を受ける処理
                        
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
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}
