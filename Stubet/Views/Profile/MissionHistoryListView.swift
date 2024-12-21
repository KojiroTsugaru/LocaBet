//
//  MissionHistoryListView.swift
//  Stubet
//
//  Created by KJ on 12/12/24.
//

import SwiftUI

struct MissionHistoryListView: View {
    @StateObject private var betManager = BetManager.shared

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            if betManager.getMissionHistory().count > 0 {
                ForEach(betManager.getMissionHistory()) { mission in
                    MissionListCell(mission: mission)
                }
            } else {
                LazyVStack(alignment: .center) {
                    Text("過去のミッションが見つかりません")
                }
            }
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    MissionHistoryListView()
}
