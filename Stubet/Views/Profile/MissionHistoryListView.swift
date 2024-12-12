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
                Text("過去のミッションがありません")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: 250)
            }
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    MissionHistoryListView()
}
