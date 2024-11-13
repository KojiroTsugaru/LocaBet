//
//  ProfileView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/06.
//

import SwiftUI

struct ProfileView: View {
    
    @ObservedObject private var viewModel: ProfileViewModel
    
    init() {
        self.viewModel = ProfileViewModel()
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("My Profile")
                .font(.headline)
            Text(viewModel.user?.userName ?? "null")
        }
        .background(Color(UIColor.systemGroupedBackground))
        .edgesIgnoringSafeArea(.all)
        .navigationTitle("プロフィール")
        .navigationBarTitleDisplayMode(.inline)

    }
}
