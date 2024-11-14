import Foundation
import Combine
import FirebaseFirestore
import SwiftUI

class HomeViewModel: ObservableObject {
    @StateObject private var betManager = BetManager.shared

    func fetchData() async {
        DispatchQueue.main.async {
            withAnimation {
                self.betManager.fetchData()
            }
        }
}
    
}
