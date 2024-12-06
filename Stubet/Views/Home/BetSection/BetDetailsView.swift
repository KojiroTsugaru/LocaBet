//
//  BetDetailsView.swift
//  Stubet
//
//  Created by KJ on 9/5/24.
//

import SwiftUI
import FirebaseFirestore

struct BetDetailsView: View {
    
    let bet: Bet
    
    var body: some View {
        VStack {
            // Invite Response Buttons
            if bet.status == .rewardPending {
                Button(action: {
                    // 報酬を受け取ったアクション
                    Task {
                        await BetManager.shared.updateBetStatus(betItem: bet, newStatus: .rewardReceived)
                    }
                }) {
                    Text("報酬を受け取った")
                        .frame(maxWidth: 24, maxHeight: 16)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text("木嶋陸")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Text(bet.title)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }
                    
                    Text("ベット内容")
                        .font(.headline)
                    Text(bet.description)
                        .font(.body)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 1)

                    // Location&Time
                    VStack(alignment: .leading) {
                        Text("場所＆時間")
                            .font(.headline)
                        TimeLocationDetailsPanel(betItem: bet)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Menu(content: {
                Button("諦める", action: {
                    // このミッションを諦めるアクション
                    
                })
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
            })
        )
    }
}
