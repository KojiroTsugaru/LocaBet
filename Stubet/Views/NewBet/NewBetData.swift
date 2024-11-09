//
//  BetData.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation

class NewBetData: ObservableObject {
    @Published var selectedFriend: Friend?
    @Published var title: String = ""
    @Published var description: String = ""
    @Published var date: Date = Date()
    @Published var time: Date = Date()
    @Published var locationName: String = ""
    @Published var selectedCoordinates: IdentifiableCoordinate?
}
