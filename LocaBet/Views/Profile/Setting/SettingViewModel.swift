//
//  SettingViewModel.swift
//  Stubet
//
//  Created by KJ on 1/4/25.
//

import Foundation

class SettingViewModel: ObservableObject {
    
    @Published var isDeletingAccount = false
    
    @MainActor
    public func deleteAccount() async throws {
        do {
            isDeletingAccount = true
            BetManager.shared.emptyAllData()
            FriendManager.shared.emptyAllData()
            NotificationManager.shared.stopListening()
            try await AccountManager.shared.deleteAccount()
            isDeletingAccount = false
        } catch {
            print("error deleting account: ", error)
        }
    }
    
    // signout func
    public func signout() async throws {
        do {
            await BetManager.shared.emptyAllData()
            await FriendManager.shared.emptyAllData()
            NotificationManager.shared.stopListening()
            try await AccountManager.shared.signOut()
        } catch {
            print(error)
        }
    }
}
