//
//  ProfileViewModel.swift
//  Stubet
//
//  Created by KJ on 11/13/24.
//

import Foundation

class ProfileViewModel: ObservableObject {
    
    @Published var user: User?
    
    init() {
        Task.init {
            user = try await fetchUser()
        }
    }
    
    private func fetchUser() async throws -> User? {
        return try await AccountManager.shared.getUser()
    }
    
}
