//
//  LocationModel.swift
//  Stubet
//
//  Created by KJ on 9/4/24.
//

import Foundation
import CoreLocation

struct Location: Codable {
    let name: String        // Name of the location
    let latitude: Double    // Latitude of the location
    let longitude: Double   // Longitude of the location

    // Initialize from Firebase document data
    init(data: [String: Any]) {
        self.name = data["name"] as! String
        self.latitude = data["latitude"] as! Double
        self.longitude = data["longitude"] as! Double
    }
}
