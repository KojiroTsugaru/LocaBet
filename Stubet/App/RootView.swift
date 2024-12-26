//
//  RootView.swift
//  Stubet
//
//  Created by KJ on 11/13/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var accountManager = AccountManager.shared

    var body: some View {
        Group {
            if accountManager.isAuthenticating {
                SplashScreenView()
            } else if accountManager.currentUser == nil {
                LoginView() // Show SignInView if the user is not logged in
            } else {
                MainTabView() // Show MainTabView if the user is logged in
            }
        }
    }
}

#Preview {
    RootView()
}
