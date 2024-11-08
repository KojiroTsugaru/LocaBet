//
//  LocationService.swift
//  Stubet
//
//  Created by KJ on 11/8/24.
//

import Foundation
import MapKit

struct SearchCompletions: Identifiable {
    let id = UUID()
    let title: String
    let subTitle: String
    var url: URL?
}


@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter

    var completions = [SearchCompletions]()

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(queryFragment: String) {
        completer.resultTypes = .pointOfInterest
        completer.queryFragment = queryFragment
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
            completions = completer.results.map { completion in
                // Get the private _mapItem property
                let mapItem = completion.value(forKey: "_mapItem") as? MKMapItem

                return .init(
                    title: completion.title,
                    subTitle: completion.subtitle,
                    url: mapItem?.url
                )
            }
        }
}
