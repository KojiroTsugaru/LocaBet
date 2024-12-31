//
//  BetModalViewModel.swift
//  Stubet
//
//  Created by KJ on 12/31/24.
//

import Foundation

class ModalViewModel: ObservableObject {
    
    let betId: String
    @Published var betItem: (any BetItem)?
    @Published var opponent: User?
    
    init(betId: String) {
        self.betId = betId
    }
    
    @MainActor
    func fetchData() async {
        self.betItem = await BetManager.shared.fetchBetBy(id: betId)
        
        if let betItem = self.betItem {
            // Perform actions based on the type of betItem
            
            // action if Bet type
            if let bet = betItem as? Bet {
                do {
                    self.opponent = try await AccountManager.shared
                        .fetchUser(id: bet.receiverId)
                } catch {
                    print("error: fetching modal data", error)
                }
                
                // action if Mission type
            } else if let mission = betItem as? Mission {
                do {
                    self.opponent = try await AccountManager.shared
                        .fetchUser(id: mission.senderId)
                } catch {
                    print("error: fetching modal data", error)
                }
                
            }
        }
    }
    
}
