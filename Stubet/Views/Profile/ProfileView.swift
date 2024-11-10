//
//  ProfileView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/06.
//

import SwiftUI

struct ProfileView: View {
    
    var body: some View {
        Group {
            VStack(spacing: 20) {
                Text("My Profile")
                    .font(.headline)
            }
        }.background(Color(UIColor.systemGroupedBackground))
            .edgesIgnoringSafeArea(.bottom)
            .navigationTitle("プロフィール")
            .navigationBarTitleDisplayMode(.inline)
    }
}
