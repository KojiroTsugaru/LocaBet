//
//  BetData.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import CoreLocation

class NewBetData: ObservableObject {
    @Published var selectedFriend: Friend
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var time: Date = Date()
    @Published var locationName: String = ""
    @Published var selectedCoordinates: CLLocationCoordinate2D?
    
    // for dummy data
    init(selectedFriend: Friend = Friend(
        id: "friend001",
        data: [
            "userName": "john_doe",
            "displayName": "John Doe",
            "addedAt": Date(), // 現在の日時
            "iconUrl": "https://example.com/user_icon/johndoe.png"
        ]
    ), title: String, description: String, date: Date = Date(), time: Date = Date(), locationName: String, selectedCoordinates: CLLocationCoordinate2D? = nil) {
        self.selectedFriend = selectedFriend
        self.title = title
        self.description = description
        self.date = date
        self.time = time
        self.locationName = locationName
        self.selectedCoordinates = selectedCoordinates
    }
}
