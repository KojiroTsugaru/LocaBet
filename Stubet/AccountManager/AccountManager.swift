//
//  AccountManager.swift
//  Stubet
//
//  Created by KJ on 11/10/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class AccountManager: NSObject {
    
    static let shared = AccountManager()
    
    // ローカルの現在のユーザーを保持するためのPublishedプロパティ
    @Published var currentUser: FirebaseAuth.User?
    @Published var handle: AuthStateDidChangeListenerHandle?
    
    private override init() {
        super.init()
        self.setUp()
    }
    
    // ユーザーがログインしているか確認するメソッド
    func setUp() {
        self.handle = Auth.auth().addStateDidChangeListener({ [weak self] auth, user in
            if let self = self {
                self.currentUser = user
                if user != nil {
                    print("User is logged in")
                } else {
                    print("User is logged out")
                }
            }
        })
    }
    
    // cleanup method to remove the listener if needed
    func removeAuthListener() {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
            self.handle = nil
        }
    }
    
    func signUp(password: String, userName: String, displayName: String, iconUrl: String) async throws {
        
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
                "iconUrl": iconUrl,
                "email": email,
                "createdAt": Timestamp(date: Date()),
                "updatedAt": Timestamp(date: Date())
            ]
            
            // Save user data to Firestore
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(user.uid)
            try await userRef.setData(userData)
            
        } catch {
            print(error)
        }
    }
    
    // MARK: - Sign-In Method
    func signIn(userName: String, password: String) async throws {
        let email = "\(userName)@stubetapp.com" // Construct a placeholder email using username
        
        do {
            // Attempt to sign in with Firebase Authentication
            let authResult = try await Auth.auth().signIn(withEmail: email, password: password)
            self.currentUser = authResult.user // Update the currentUser on successful sign-in
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
    func signOut() throws {
        do {
            try Auth.auth().signOut()
            self.currentUser = nil // Clear the current user on sign-out
        } catch {
            throw SignInError.signOutFailed
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
