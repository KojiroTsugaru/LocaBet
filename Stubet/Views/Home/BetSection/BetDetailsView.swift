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
//                    TimeLocationCell(newBetData: newBetData)
                }
            }
            .padding()
                
            // Invite Response Buttons
            if bet.status == "invitePending" {
                //                if true {
                VStack() {
                    Button(action: {
                        // 申請を受ける処理
                    }) {
                        Text("受ける")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                        
                    Button(action: {
                        // 申請を拒否する処理
                    }) {
                        Text("拒否する")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                }
                .padding()
            }
                
            Spacer()
        }
        .navigationTitle("詳細")
        .navigationBarTitleDisplayMode(.inline)
    }
}
