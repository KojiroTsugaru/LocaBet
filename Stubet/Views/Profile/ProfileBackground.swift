//
//  ProfileBackground.swift
//  Stubet
//
//  Created by KJ on 12/26/24.
//

import SwiftUI

struct ProfileBackground: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                // Top 1/3 background color
                Color.orange
                    .frame(height: geometry.size.height / 5)
                
                // Main background color
                Color(UIColor.systemGroupedBackground)
            }
        }.ignoresSafeArea(edges: .top)
    }
}


#Preview {
    ProfileBackground()
}
