import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

class HomeViewModel: ObservableObject {
    
    enum Tab {
        case mission
        case bet
    }
    
    @Published var selectedTab: Tab = .mission
    let betMissionManager = BetMissionManager.shared

    func fetchData() {
        betMissionManager.fetchData()
    }
    
}
