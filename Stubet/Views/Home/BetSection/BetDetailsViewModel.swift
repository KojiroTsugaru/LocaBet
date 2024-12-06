//
//  BetDetailsViewMode.swift
//  Stubet
//
//  Created by KJ on 12/6/24.
//

import Foundation

@MainActor
class BetDetailsViewModel: ObservableObject {
    
    @Published var isUpdating = false
    @Published var updateMessage = ""
    
    func receiveBetReward(bet: Bet) async {
        // 申請を拒否する処理
        isUpdating = true
        updateMessage = "報酬受け取り処理中..."
        
        await BetManager.shared
            .updateBetStatus(
                betItem: bet,
                newStatus: .rewardReceived
            )
        
        updateMessage = ""
        isUpdating = false
    }
    
    func deleteBet(bet: Bet) async {
        // 申請を拒否する処理
        isUpdating = true
        updateMessage = "ベットを削除しています..."
        
        await BetManager.shared
            .updateBetStatus(
                betItem: bet,
                newStatus: .failed
            )
        
        updateMessage = ""
        isUpdating = false
    }
}
