//
//  MainTabViewModel.swift
//  Stubet
//
//  Created by KJ on 12/6/24.
//

import Foundation
import SwiftUI
import CoreLocation

class MainTabViewModel: ObservableObject {
    init() {
        Task {
            await fetchAllData()
        }
        
        // start tracking user's location
        LocationManager.shared.checkLocationAuthorization()
    }
    
    // fetch current user, bet data, and locations
    func fetchAllData() async {
        do {
            try await AccountManager.shared.fetchCurrentUser()
            await BetManager.shared.fetchData()
            await self.addLocationTargets()
        } catch {
            print("error fething all data: ", error)
        }
    }
    
    @MainActor
    private func addLocationTargets() async {
        for mission in BetManager.shared.ongoingMissions {
            let location = mission.location
            LocationManager.shared
                .startGeofencingRegion(
                    center: CLLocationCoordinate2D(
                        latitude: location.latitude,
                        longitude: location.longitude
                    ),
                    identifier: "#\(mission.id)-\(location.name)"
                )
        }
    }
    
}
