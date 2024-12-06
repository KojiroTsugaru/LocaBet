//
//  BetData.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import CoreLocation

class NewBetData: ObservableObject {
    @Published var selectedFriend: Friend?
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var time: Date = Date()
    @Published var locationName: String = ""
    @Published var selectedCoordinates: CLLocationCoordinate2D
    
    // for dummy data
    init(selectedFriend: Friend = Friend(
        id: "friend001",
        data: [
            "userName": "John",
            "displayName": "John",
            "addedAt": Date(), // 現在の日時
            "iconUrl": "https://example.com/user_icon/johndoe.png"
        ]
    ), title: String, description: String, date: Date = Date(), time: Date = Date(), locationName: String, selectedCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()) {
        self.selectedFriend = selectedFriend
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.locationName = locationName
        self.selectedCoordinates = selectedCoordinates
    }
    
    init(
        title: String,
        description: String,
        date: Date = Date(),
        time: Date = Date(),
        locationName: String,
        selectedCoordinates: CLLocationCoordinate2D = CLLocationCoordinate2D()
    ) {
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.locationName = locationName
        self.selectedCoordinates = selectedCoordinates
    }
}
