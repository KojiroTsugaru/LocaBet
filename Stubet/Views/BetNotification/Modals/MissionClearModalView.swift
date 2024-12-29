//
//  MissionClearModalView.swift
//  Stubet
//
//  Created by KJ on 11/9/24.
//

import SwiftUI

struct MissionClearModalView: View {
    
    let missionId: String
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ミッションをクリアしました🎉")
                .font(.title2)
                .bold()
            Text("に時間通りに到着")
                .bold()

            Button("閉じる") {
                // Code to dismiss modal will automatically work with the sheet binding
                dismiss()
            }
        }
        .padding()
    }
}

//#Preview {
//    MissionClearModalView(regionIdentifier: "Test Location")
//}
