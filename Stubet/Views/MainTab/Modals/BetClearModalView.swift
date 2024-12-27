//
//  BetClearModalView.swift
//  Stubet
//
//  Created by KJ on 12/27/24.
//

import SwiftUI

struct BetClearModalView: View {
    
    let regionIdentifier: String
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ベットをクリアしました🎉")
                .font(.title2)
                .bold()
            Text("\(regionIdentifier)に時間通りに到着")
                .bold()

            Button("閉じる") {
                // Code to dismiss modal will automatically work with the sheet binding
            }
        }
        .padding()
    }
}

#Preview {
    BetClearModalView(regionIdentifier: "Test Location")
}
