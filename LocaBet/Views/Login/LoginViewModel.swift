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
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    @MainActor
    func signIn() async {
        do {
            isLoading = true
            try await AccountManager.shared
                .signIn(
                    userName: userName,
                    password: password
                )
            isLoading = false
        } catch {
            errorMessage = error.localizedDescription
            isLoading = false
        }
    }
}
