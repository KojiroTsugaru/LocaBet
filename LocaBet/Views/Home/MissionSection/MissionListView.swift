//
//  MissionSectionView.swift
//  Stubet
//
//  Created by KJ on 11/14/24.
//

import SwiftUI

struct MissionListView: View {
    @StateObject private var betManager = BetManager.shared

    var body: some View {
        LazyVStack(alignment: .leading, spacing: 20) {
            if betManager.newMissions.count > 0 {
                Text("新しいミッションが届いています")
                    .font(.headline)
                    .padding(.leading)
            
                ForEach(betManager.newMissions) { mission in
                    MissionListCell(mission: mission)
                }
            }
        
            if betManager.ongoingMissions.count > 0 {
                Text("進行中のミッション")
                    .font(.headline)
                    .padding(.leading)
            
                ForEach(betManager.ongoingMissions) { mission in
                    MissionListCell(mission: mission)
                }
            } else {
                Text("進行中のミッションはありません")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .offset(y: 250)
            }
        }
        .padding(.bottom, 100)
    }
}
