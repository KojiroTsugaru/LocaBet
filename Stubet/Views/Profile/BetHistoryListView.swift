//
//  BetHistoryListView.swift
//  Stubet
//
//  Created by KJ on 12/12/24.
//

import SwiftUI

struct BetHistoryListView: View {
    @StateObject private var betManager = BetManager.shared

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            if betManager.getBetHistory().count > 0 {
                ForEach(betManager.getBetHistory()) { bet in
                    BetListCell(bet: bet)
                }
            } else {
                LazyVStack(alignment: .center) {
                    Text("過去のベットが見つかりません")
                }
            }
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    BetHistoryListView()
}
