//
//  RootView.swift
//  Stubet
//
//  Created by KJ on 11/13/24.
//

import SwiftUI

struct RootView: View {
    @StateObject private var accountManager = AccountManager.shared
    @State private var isAuthenticating = true

    var body: some View {
        Group {
            if isAuthenticating {
                SplashScreenView()
            } else {
                if accountManager.currentUser != nil {
                    MainTabView() // Show MainTabView if the user is logged in
                } else {
                    LoginView() // Show SignInView if the user is not logged in
                }
            }
        }
        .onChange(of: accountManager.currentUser, { _, _ in
            isAuthenticating = false // Update the authentication state once the process is complete
        })
    }
}

#Preview {
    RootView()
}
