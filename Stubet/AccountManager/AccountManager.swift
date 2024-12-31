//
//  AccountManager.swift
//  Stubet
//
//  Created by KJ on 11/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth

class AccountManager: NSObject, ObservableObject {
    
    static let shared = AccountManager()
    private let db = Firestore.firestore()
    private let storage = Storage.storage()
    // ローカルの現在のユーザーを保持するためのPublishedプロパティ
    @Published var currentUser: User?
    @Published var handle: AuthStateDidChangeListenerHandle?
    @Published var isAuthenticating = true
    
    private override init() {
        super.init()
        self.setUp()
    }
    
    // ユーザーがログインしているか確認するメソッド
    func setUp() {
        self.handle = Auth
            .auth()
            .addStateDidChangeListener({ [weak self] auth, user in
                if let self = self {
                    DispatchQueue.main.async {
                        Task {
                            self.currentUser = try await self.fetchCurrentUser()
                            self.isAuthenticating = false
                        }
                        if user != nil {
                            print("User is logged in")
                        } else {
                            print("User is logged out")
                            self.currentUser = nil // Clear the current user if logged out
                        }
                    }
                }
            })
    }
    
    /// cleanup method to remove the listener if needed
    func removeAuthListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
            self.handle = nil
        }
    }
    
    /// Upload the profile image to Firebase Storage using async/await.
    func uploadIconImage(iconImage: UIImage?) async throws -> URL {
        guard let image = iconImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            throw NSError(
                domain: "ImageError",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Invalid image."]
            )
        }

        let imageName = UUID().uuidString
        let storageRef = storage.reference().child(
            "profileImages/\(imageName).jpg"
        )

        // Upload the image
        let _ = try await storageRef.putDataAsync(imageData)

        // Retrieve the download URL
        let downloadURL = try await storageRef.downloadURL()
        return downloadURL
    }
    
    func signUp(password: String, userName: String, displayName: String, iconImageUrl: URL?) async throws {
        
        // sign up with fake email address
        let email = "\(userName)@stubetapp.com"
        
        do {
            // Attempt to create a new user in Firebase Authentication
            let authResult = try await Auth.auth().createUser(
                withEmail: email,
                password: password
            )
            let user = authResult.user
            
            // Prepare user data for Firestore
            let userData: [String: Any] = [
                "userName": userName,
                "displayName": displayName,
                "iconUrl": iconImageUrl?.absoluteString ?? "" ,
                "email": email,
                "createdAt": Timestamp(date: Date()),
                "updatedAt": Timestamp(date: Date()),
            ]

            
            let userRef = db.collection("users").document(user.uid)
            try await userRef.setData(userData)
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Sign-In Method
    @MainActor
    func signIn(userName: String, password: String) async throws {
        let email = "\(userName)@stubetapp.com" // Construct a placeholder email using username
        
        do {
            // Attempt to sign in with Firebase Authentication
            _ = try await Auth.auth().signIn(
                withEmail: email,
                password: password
            )
            
            Task {
                self.currentUser = try await fetchCurrentUser() // Update the currentUser on successful sign-in
            }
            
        } catch let error as NSError {
            // Handle specific Firebase Authentication errors if needed
            switch AuthErrorCode(rawValue: error.code) {
            case .invalidEmail:
                throw SignInError.invalidEmail
            case .wrongPassword:
                throw SignInError.wrongPassword
            case .userNotFound:
                throw SignInError.userNotFound
            case .userDisabled:
                throw SignInError.userDisabled
            default:
                throw SignInError.unknownError(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Sign-Out Method
    @MainActor
    func signOut() async throws {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil // Clear the current user on sign-out
        } catch {
            throw SignInError.signOutFailed
        }
    }
    
    // userIDの取得
    public func getCurrentUserId() -> String? {
        return currentUser?.id
    }

    // convert Firestore data to User struct
    public func fetchCurrentUser() async throws -> User? {
        
        // Ensure that we have a current user
        guard let id = Auth.auth().currentUser?.uid else {
            return nil
        }
        
        // Reference to the Firestore document
        let documentRef = Firestore.firestore().collection("users").document(id)
        
        do {
            // Fetch the document
            let documentSnapshot = try await documentRef.getDocument()
            
            // Check if the document exists and contains data
            guard let data = documentSnapshot.data() else {
                print("In fetchCurrentUser(): User document does not exist or has no data")
                return nil
            }
            
            async let currentUser = await User(id: id, data: data)
            return await currentUser
            
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            throw error
        }
    }
    
    public func setCurrentUser() async throws {
        self.currentUser = try await fetchCurrentUser()
    }
    
    // fetch user by user id
    public func fetchUser(id: String) async throws -> User? {
        // Reference to the Firestore document
        let documentRef = Firestore.firestore().collection("users").document(id)
        
        do {
            // Fetch the document
            let documentSnapshot = try await documentRef.getDocument()
            
            // Check if the document exists and contains data
            guard let data = documentSnapshot.data() else {
                print("In fetchUser(id: String): User document does not exist or has no data")
                return nil
            }
            
            return await User(id: id, data: data)
            
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
            throw error
        }
    }
    
    func updateCurrentUser(
        newUserName: String,
        newDisplayName: String,
        newIconUrl: String
    ) {
        
        guard let currentUser = self.currentUser else {
            print("Error: User ID is missing.")
            return
        }
        
        let userData: [String: Any] = [
            "userName": newUserName,
            "displayName": newDisplayName,
            "iconUrl": newIconUrl,
            "email": currentUser.email,
            "createdAt": Timestamp(date: Date()),
            "updatedAt": Timestamp(date: Date()),
        ]
        
        db
            .collection("users")
            .document(currentUser.id)
            .updateData(userData) { error in
                if let error = error {
                    print("Error updating user: \(error.localizedDescription)")
                } else {
                    print("User updated successfully.")
                }
            }
    }
    
    // Custom error types for sign-in error handling
    enum SignInError: LocalizedError {
        case invalidEmail
        case wrongPassword
        case userNotFound
        case userDisabled
        case unknownError(String)
        case signOutFailed
        
        var errorDescription: String? {
            switch self {
            case .invalidEmail:
                return "The email address format is invalid. Please enter a valid email."
            case .wrongPassword:
                return "The password you entered is incorrect. Please try again."
            case .userNotFound:
                return "No account found with the provided credentials."
            case .userDisabled:
                return "This account has been disabled. Please contact support."
            case .unknownError(let message):
                return message
            case .signOutFailed:
                return "Failed to sign out. Please try again."
            }
        }
    }
    
}
