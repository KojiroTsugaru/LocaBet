//
//  Untitled.swift
//  Stubet
//
//  Created by KJ on 12/6/24.
//

import Foundation
import SwiftUI
import CoreLocation

@MainActor
class MissionDetailsViewModel: ObservableObject {
    
    @Published var isUpdating = false
    @Published var updateMessage = ""
    
    func rejectMissionRequest(mission: Mission) async {
        // 申請を拒否する処理
        isUpdating = true
        updateMessage = "ベット申請を拒否しています..."
        
        await BetManager.shared
            .updateBetStatus(
                betItem: mission,
                newStatus: .inviteRejected
            )
        
        updateMessage = ""
        isUpdating = false
    }
    
    func acceptMissionRequest(mission: Mission) async {
        isUpdating = true
        updateMessage = "ベット申請を許可しています..."
        // Geofencingにこのロケーションを追加する
        LocationManager.shared
            .startGeofencingRegion(
                center: CLLocationCoordinate2D(
                    latitude: mission.location.latitude,
                    longitude: mission.location.longitude
                ),
                identifier: mission.location.name
            )
        // ステータスを変更
        await BetManager.shared
            .updateBetStatus(
                betItem: mission,
                newStatus: .ongoing
            )
        updateMessage = ""
        isUpdating = false
    }
    
    func giveupMission(mission: Mission) async {
        isUpdating = true
        updateMessage = "ミッションを削除しています..."
        // ステータスを変更
        
        await BetManager.shared
            .updateBetStatus(
                betItem: mission,
                newStatus: .failed
            )
        
        
        updateMessage = ""
        isUpdating = false
    }
    
}
