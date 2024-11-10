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
    
    // ローカルの現在のユーザーを保持するためのPublishedプロパティ
    @Published var currentUser: FirebaseAuth.User?
    @Published var handle: NSObjectProtocol
    
    func signup(password: String, userName: String, displayName: String, iconUrl: String) async throws {
        
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
    
    private func signInCompleted() {
        print("User is logged in!")
        currentUser = Auth.auth().currentUser
    }
    
    // ユーザーがログインしているか確認するメソッド
    func setup() {
        self.handle = Auth.auth().addStateDidChangeListener({ auth, user in
            
            if user != nil {
                self.signInCompleted()
            } else {
                self.currentUser = nil
            }
        })
    }
    
    
    // ユーザー認証を行うメソッド
    func authenticationStatusCheck(complition: ((Bool) -> Void)? = nil) {
        Auth.auth().addStateDidChangeListener { (_, user) in
            // ユーザー情報があるかどうかをBool値で判断する
            if user == nil {
                // 新規ユーザーの場合
                complition?(false)

            } else {
                // ログイン済みユーザーの場合
                complition?(true)
            }
        }
    }

    
    static let shared = AccountManager()
    
    private override init() {
        super.init()
        self.setup()
    }
    
}
