//
//  BetListView.swift
//  Stubet
//
//  Created by KJ on 11/14/24.
//

import SwiftUI

struct BetListView: View {
    @StateObject private var betManager = BetManager.shared

    var body: some View {
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

