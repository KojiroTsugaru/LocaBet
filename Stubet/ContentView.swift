import SwiftUI
import Firebase
import FirebaseAuth

struct ContentView: View {
    
    init() {
        // Set tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView {
            // Home tab with NavigationView
            NavigationView {
                HomeView()
            }
            .tabItem {
                Image(systemName: "house")
                Text("ホーム")
            }

            
            NavigationView {
                ProfileView()
            }
            .tabItem {
                Image(systemName: "person.fill")
                Text("プロフィール")
            }
        }.accentColor(Color.orange)
        
    }
}
