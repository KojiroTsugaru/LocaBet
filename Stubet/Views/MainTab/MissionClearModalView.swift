//
//  MissionClearModalView.swift
//  Stubet
//
//  Created by KJ on 11/9/24.
//

import SwiftUI

struct MissionClearModalView: View {
    
    let regionIdentifier: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ミッションをクリアしました🎉")
                .font(.title2)
                .bold()
            Text("\(regionIdentifier)に時間内に到着")
                .bold()

            Button("閉じる") {
                // Code to dismiss modal will automatically work with the sheet binding
            }
        }
        .padding()
    }
}

#Preview {
    MissionClearModalView(regionIdentifier: "Test Location")
}
