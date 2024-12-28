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
    
    private var timer: AnyCancellable?
    private var notificationListener: ListenerRegistration?
    
    @Published var showMissionClearModal = false
    @Published var showMissionFailModal = false
    @Published var showBetClearModal = false
    @Published var showBetFailModal = false
    
    // for notification modal
    @Published var betNotifications: [BetNotification] = [] // (betId, ModalType)
    @Published var currentNotification: BetNotification? = nil // Current notification
    
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
                    // change bet status to cleared
                    await betManager
                        .updateBetStatus(
                            betItem: mission,
                            newStatus: .rewardPending
                        )
                    // notify status update to sender
                    await betManager.notifyStatusUpdateTo(id: mission.senderId, betId: mission.id, newStatus: .rewardPending)
                    
                    // add it to notification for modal
                    self.betNotifications.append(BetNotification(id: mission.id, type: .missionClear))
                    
                } else {
                    // change bet status to fail
                    await betManager
                        .updateBetStatus(betItem: mission, newStatus: .failed)
                    // notify status update to sender
                    await betManager.notifyStatusUpdateTo(id: mission.senderId, betId: mission.id, newStatus: .failed)
                    
                    // add it to notification for modal
                    self.betNotifications.append(BetNotification(id: mission.id, type: .missionFail))
                }
                // stop geofencing this mission location
                locationManager.stopGeofencingRegion(identifier: mission.id)
                await betManager.fetchData()
            }
        }
    }
    
    func startListeningForNotifications() {
        let db = Firestore.firestore()
        
        guard let currenUserId = accountManager.getCurrentUserId() else {
            return
        }
        
        notificationListener = db
            .collection("users")
            .document(currenUserId)
            .collection("notifications")
            .order(by: "timestamp", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                if let error = error {
                    print("Error fetching notifications: \(error)")
                    return
                }

                guard let documents = snapshot?.documents else { return }
                for document in documents {
                    let data = document.data()
                    if let type = data["type"] as? String,
                       let newStatus = data["newStatus"] as? String,
                       let betId = data["betId"] as? String,
                       type == "statusUpdate" {
                        
                        // bet was failed
                        if newStatus == Status.failed.rawValue {
                            // add it to notification for modal
                            betNotifications.append(BetNotification(id: betId, type: .betFail))
                            break
                        }
                        // bet was cleared
                        else if newStatus == Status.rewardPending.rawValue {
                            betNotifications.append(BetNotification(id: betId, type: .betClear))
                            break
                        }
                    }
                }
            }
    }
    
    /// Show the next notification modal
    func showNextNotification() {
        if self.currentNotification == nil, !self.betNotifications.isEmpty {
            self.currentNotification = self.betNotifications.removeFirst() // Show the next notification
        } else {
            self.currentNotification = nil // All notifications shown
        }
    }
    
    
    deinit {
        timer?.cancel()
        notificationListener?.remove()
    }
}
