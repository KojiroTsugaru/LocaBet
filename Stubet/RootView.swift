//
//  RootView.swift
//  Stubet
//
//  Created by KJ on 11/13/24.
//

import SwiftUI

struct RootView: View {
    let accountManager = AccountManager.shared

    var body: some View {
        Group {
            if accountManager.currentUser != nil {
                MainTabView() // Show MainTabView if the user is logged in
            } else {
                LoginView() // Show SignInView if the user is not logged in
            }
        }
        .onAppear {
            accountManager.setUp() // Ensure the listener is set up when the app starts
        }
    }
}

#Preview {
    RootView()
}
