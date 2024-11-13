//
//  LoginViewModel.swift
//  Stubet
//
//  Created by HAGIHARA KADOSHIMA on 2024/09/04.
//

import Foundation
import SwiftUI
import Combine
import FirebaseAuth
import FirebaseFirestore

class LoginViewModel: ObservableObject {
    @Published var userName = ""
    @Published var password = ""
    @Published var showError = false
    @Published var userData: [String: Any]? = nil
    
    @MainActor
    func login() async {
        do {
            try await AccountManager.shared.signIn(userName: "testuser", password: "securePassword")
            print("User signed in successfully")
        } catch let error as AccountManager.SignInError {
            print("Sign-in error: \(error.localizedDescription)")
        } catch {
            print("Unexpected error: \(error.localizedDescription)")
        }
    }
}
