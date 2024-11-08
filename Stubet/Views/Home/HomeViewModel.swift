import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

class HomeViewModel: ObservableObject {
    
    @Published var selectedTab: Tab = .mission
    
    enum Tab {
        case mission
        case bet
    }

    init() {
        
    }
}
