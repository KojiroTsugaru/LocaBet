//
//  LocationSettingViewModel.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import MapKit

class SetLocationViewModel: ObservableObject {
    
    @Published var searchText: String = ""
    @Published var selectedCoordinates: [IdentifiableCoordinate] = []
    @Published var region: MKCoordinateRegion
    
    let mapManager = CLLocationManager()
    
    init(searchText: String, selectedCoordinates: [IdentifiableCoordinate], region: MKCoordinateRegion) {
        self.searchText = searchText
        self.selectedCoordinates = selectedCoordinates
        self.region = region
    }
}
