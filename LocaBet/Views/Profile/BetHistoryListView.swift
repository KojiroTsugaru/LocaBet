//
//  BetHistoryListView.swift
//  Stubet
//
//  Created by KJ on 12/12/24.
//

import SwiftUI

struct BetHistoryListView: View {
    @StateObject private var betManager = BetManager.shared
    @State private var betHistory: [Bet] = []

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            if betHistory.count > 0 {
                
                // bet history list
                ForEach(betHistory) { bet in
                    BetListCell(bet: bet)
                }
                
                // filling up the white space
                if betHistory.count == 1 {
                    Spacer()
                        .frame(height: 200)
                }
                else if betHistory.count == 2 {
                    Spacer()
                        .frame(height: 100)
                }
            } else {
                VStack(alignment: .center) {
                    Text("過去のベットが見つかりません")
                        .frame(height: 350, alignment: .top)
                        .padding()
                }
            }
        }
        .padding(.bottom, 100)
        .onAppear {
            self.betHistory = betManager.getBetHistory()
        }
    }
}

#Preview {
    BetHistoryListView()
}
