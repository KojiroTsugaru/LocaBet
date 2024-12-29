//
//  BetClearModalView.swift
//  Stubet
//
//  Created by KJ on 12/27/24.
//

import SwiftUI

struct BetClearModalView: View {
    
    let betId: String
    let dismiss: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ベットをクリアしました🎉")
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
//    BetClearModalView(regionIdentifier: "Test Location")
//}
