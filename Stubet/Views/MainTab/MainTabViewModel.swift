//
//  MainTabViewModel.swift
//  Stubet
//
//  Created by KJ on 12/6/24.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine
import Firebase

class MainTabViewModel: ObservableObject {
    
    @ObservedObject private var betManager = BetManager.shared
    @ObservedObject private var accountManager = AccountManager.shared
    @ObservedObject private var locationManager = LocationManager.shared
    @ObservedObject private var notificationManager = NotificationManager.shared
    
    private var timer: AnyCancellable?
    private var notificationListener: ListenerRegistration?
    
    @Published var showMissionClearModal = false
    @Published var showMissionFailModal = false
    @Published var showBetClearModal = false
    @Published var showBetFailModal = false
    
    init() {
        Task {
            await fetchAllData()
            
            // start listening to notifications
            startListeningForNotifications()
        }
        
        // start tracking user's location
        locationManager.checkLocationAuthorization()
        // timer for mission progress check
        startTimer()
    }
    
    // fetch current user, bet data, and locations
    func fetchAllData() async {
        do {
            accountManager.currentUser = try await accountManager
                .fetchCurrentUser()
            await betManager.fetchData()
            await self.addLocationTargets()
        } catch {
            print("error fething all data: ", error)
        }
    }
    
    @MainActor
    private func addLocationTargets() async {
        for mission in betManager.ongoingMissions {
            let location = mission.location
            locationManager
                .startGeofencingRegion(
                    center: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    ),
                    identifier: mission.id
                )
        }
    }
    
    func startTimer() {
        timer = Timer.publish(every: 10, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.checkMissionsProgress()
                }
            }
    }
    
    @MainActor func checkMissionsProgress() async {
        for mission in betManager.ongoingMissions {
            
            // check if deadline was passed or not
            if mission.deadline.dateValue() < Date() {
                if locationManager.insideRegions.contains(mission.id) {
                    
                    print("a mission cleared! title: \(mission.title)")
                    
                    // change bet status to cleared
                    await betManager
                        .updateBetStatus(
                            betItem: mission,
                            newStatus: .rewardPending
                        )
                    // notify status update to sender
                    await notificationManager.notifyStatusUpdateFor(id: mission.senderId, betId: mission.id, newStatus: .rewardPending)
                    
                    // add it to notification for modal
                    NotificationManager.shared.betNotifications.append(BetNotification(id: mission.id, type: .missionClear))
                    
                } else {
                    print("a mission failed! title: \(mission.title)")
                    // change bet status to fail
                    await betManager
                        .updateBetStatus(betItem: mission, newStatus: .failed)
                    // notify status update to sender
                    await notificationManager.notifyStatusUpdateFor(id: mission.senderId, betId: mission.id, newStatus: .failed)
                    // add it to notification for modal
                    NotificationManager.shared.betNotifications.append(BetNotification(id: mission.id, type: .missionFail))
                }
                // stop geofencing this mission location
                locationManager.stopGeofencingRegion(identifier: mission.id)
                await betManager.refreshData()
            }
        }
    }
    
    // listen for bet notifications
    func startListeningForNotifications() {
        
        guard let currenUserId = accountManager.getCurrentUserId() else {
            return
        }
        
        NotificationManager.shared.startListeningForNotifications(for: currenUserId)
    }
    
    // onDismiss action for bet notification modals
    func dismissNotification(_ notification: BetNotification) {
        NotificationManager.shared.deleteNotification(notification: notification)
    }
    
    deinit {
        timer?.cancel()
        notificationListener?.remove()
    }
}
