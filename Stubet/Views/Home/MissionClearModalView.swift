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
            Text("Entered Region")
                .font(.headline)
            Text("You have entered region: \(regionIdentifier)")
            Button("Close") {
                // Code to dismiss modal will automatically work with the sheet binding
            }
        }
        .padding()
    }
}

#Preview {
    MissionClearModalView(regionIdentifier: "Test Location")
}
