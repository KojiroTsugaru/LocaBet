//
//  ScrollviewTest.swift
//  Stubet
//
//  Created by KJ on 12/26/24.
//

import SwiftUI

struct ScrollviewTest: View {
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(0..<50, id: \.self) { index in
                        Text("Item \(index)")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(8)
                    }
                }
                .padding()
            }
            .toolbarBackground(Color.blue, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
        }
    }
}


#Preview {
    ScrollviewTest()
}
