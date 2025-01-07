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
                
                // mission history list
                ForEach(betManager.getMissionHistory()) { mission in
                    MissionListCell(mission: mission)
                }
                
                // filling up the white space
                if betManager.getMissionHistory().count == 1 {
                    Spacer()
                        .frame(height: 200)
                }
                else if betManager.getMissionHistory().count == 2 {
                    Spacer()
                        .frame(height: 100)
                }
            } else {
                VStack(alignment: .center) {
                    Text("過去のミッションが見つかりません")
                        .frame(height: 350, alignment: .top)
                        .padding()
                }
            }
        }
        .padding(.bottom, 100)
    }
}

#Preview {
    MissionHistoryListView()
}
