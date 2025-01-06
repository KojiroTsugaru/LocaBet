import Foundation
import FirebaseFirestore

struct User: Identifiable, Equatable {
    let id: String              // userId (UUID or unique string)
    let userName: String        // Unique string in roman letters
    var displayName: String     // Full display name of the user
    var iconUrl: String         // URL of the user's icon
    let email: String           // Email address of the user
    let createdAt: Timestamp    // Creation timestamp
    var updatedAt: Timestamp    // Last updated timestamp
    
    var iconImage: UIImage?

    // Initialize from Firebase document data
    init(id: String, data: [String: Any]) async {
        self.id = id
        self.userName = data["userName"] as? String ?? ""
        self.displayName = data["displayName"] as? String ?? "" // 修正点: displayNameの初期化
        self.iconUrl = data["iconUrl"] as? String ?? ""
        self.email = data["email"] as? String ?? ""
        self.createdAt = data["createdAt"] as? Timestamp ?? Timestamp(
            date: Date()
        )
        self.updatedAt = data["updatedAt"] as? Timestamp ?? Timestamp(
            date: Date()
        )
        
        await fetchImage(from: iconUrl)
    }
    
    // define == for equitable
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
    
    mutating func fetchImage(from urlString: String) async {
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.iconImage = UIImage(data: data)
        } catch {
            print("Error loading image: \(error.localizedDescription)")
        }
    }
}
