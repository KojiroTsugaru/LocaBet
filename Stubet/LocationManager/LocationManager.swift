//
//  LocationManager.swift
//  Stubet
//
//  Created by KJ on 11/9/24.
//

import Foundation
import CoreLocation
import SwiftUI


class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    static let shared = LocationManager() // Singleton instance
        
    private var locationManager: CLLocationManager
    @Published var currentLocation: CLLocation?
    @Published var insideRegions: Set<String> = [] // Set of region identifiers that the user is currently inside
    @Published var showModalForRegion: String? = nil // Identifier of the region to show a modal for
    
    override private init() {
        self.locationManager = CLLocationManager()
        super.init()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    // MARK: - Location Tracking
    
    func startTrackingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }
    
    func stopTrackingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Geofencing
    
    func startGeofencingRegion(center: CLLocationCoordinate2D, radius: CLLocationDistance, identifier: String) {
        // Check if geofencing is available
        guard CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) else {
            print("Geofencing not supported on this device")
            return
        }
        
        // Define the geofence region
        let region = CLCircularRegion(center: center, radius: radius, identifier: identifier)
        region.notifyOnEntry = true
        region.notifyOnExit = true
        
        // Start monitoring the region
        locationManager.startMonitoring(for: region)
        print("Started monitoring region: \(identifier)")
    }
    
    func stopGeofencingRegion(identifier: String) {
        for region in locationManager.monitoredRegions {
            if let circularRegion = region as? CLCircularRegion, circularRegion.identifier == identifier {
                locationManager.stopMonitoring(for: circularRegion)
                insideRegions.remove(identifier) // Ensure the region is removed from the insideRegions set
                print("Stopped monitoring region with identifier: \(identifier)")
                break
            }
        }
    }
    
    
    // MARK: - CLLocationManagerDelegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("Updated Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user's location: \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            insideRegions.insert(circularRegion.identifier)
            print("Entered geofence region: \(circularRegion.identifier)")
            
            // Show modal for this region
            showModalForRegion = circularRegion.identifier
            
            // Stop monitoring this region after entering it
            locationManager.stopMonitoring(for: circularRegion)
            print("Stopped monitoring region \(circularRegion.identifier) upon entry")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        if let circularRegion = region as? CLCircularRegion {
            insideRegions.remove(circularRegion.identifier)
            print("Exited geofence region: \(circularRegion.identifier)")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("Failed to monitor region: \(region?.identifier ?? "unknown") with error: \(error.localizedDescription)")
    }
}
