//
//  ProfileEditViewModel.swift
//  Stubet
//
//  Created by KJ on 12/11/24.
//

import SwiftUI
import Combine
import FirebaseAuth
import Foundation
import FirebaseFirestore

class ProfileEditViewModel: ObservableObject {
    @Published var username = ""
    @Published var displayName = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var iconImage: UIImage?
    @Published var iconImageUrl: URL?
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    // バリデーションエラーメッセージ用のプロパティ
    @Published var usernameError: String = ""
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var confirmPasswordError: String = ""
    
    @Published var isLoading = false

    @MainActor
    init() {
        if let currentUser = AccountManager.shared.currentUser {
            username = currentUser.userName
            displayName = currentUser.displayName
            iconImageUrl = URL(string: currentUser.iconUrl)
            Task {
                iconImage = await fetchImage(from: currentUser.iconUrl)
            }
        }
    }
    
    // update user method
    @MainActor
    func updateUser() async throws {
        
        isLoading = true
        
        if let _ = self.iconImage {
            iconImageUrl = try await AccountManager.shared
                .uploadIconImage(iconImage: iconImage)
            print("Profile image uploaded to: \(iconImageUrl!)")
        }
        
        
        AccountManager.shared
            .updateCurrentUser(
                newUserName: username,
                newDisplayName: displayName,
                newIconUrl: iconImageUrl?.absoluteString ?? "url error"
            )
        
        isLoading = false
    }
    
    @MainActor
    func checkUsernameAvailability() async {
        
        let db = Firestore.firestore()
        
        guard !username.isEmpty else {
            usernameError = ""
            return
        }

        isLoading = true // Start loading
        
        do {
            let snapshot = try await db.collection("users")
                .whereField("username", isEqualTo: username)
                .getDocuments()

            if !snapshot.documents.isEmpty {
                usernameError = "このユーザー名はすでに使用されています。"
            } else {
                usernameError = ""
            }
        } catch {
            print("Error checking username: \(error.localizedDescription)")
            usernameError = "エラーが発生しました。"
        }
        
        isLoading = false // stop loading
    }
    
    func fetchImage(from urlString: String) async -> UIImage? {
        guard let url = URL(string: urlString) else { return nil }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            return UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
            return nil
        }
    }

}
