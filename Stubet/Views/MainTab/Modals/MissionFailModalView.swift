//
//  MissionFailModal.swift
//  Stubet
//
//  Created by KJ on 12/27/24.
//

import SwiftUI

struct MissionFailModalView: View {
    
    let regionIdentifier: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ミッションに失敗しました")
                .font(.title2)
                .bold()
            Text("\(regionIdentifier)に到着できませんでした")
                .bold()

            Button("閉じる") {
                // Code to dismiss modal will automatically work with the sheet binding
            }
        }
        .padding()
    }
}

#Preview {
    MissionFailModalView(regionIdentifier: "Test Location")
}
