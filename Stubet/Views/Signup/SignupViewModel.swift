//
//  SignupViewModel.swift
//  Stubet
//
//  Created by HAGIHARA KADOSHIMA on 2024/09/05.
//

import SwiftUI
import Combine
import FirebaseAuth
import Foundation
import FirebaseFirestore

class SignupViewModel: ObservableObject {
    @Published var username = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var showError = false
    @Published var errorMessage = ""
    
    // バリデーションエラーメッセージ用のプロパティ
    @Published var usernameError: String = ""
    @Published var emailError: String = ""
    @Published var passwordError: String = ""
    @Published var confirmPasswordError: String = ""

    init() {
        // 必要に応じて、初期値を設定
    }
        
    func signup() async throws {
        // エラーがなければ続行
        if usernameError.isEmpty && emailError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty {
           
            // TODO：ユーザーネームとパスワードの画面とそれ以外の詳細入力画面を分ける
            
            // サインアップする
            try await AccountManager.shared.signUp(password: password, userName: username, displayName: username, iconUrl: "")
            
        } else {
            showError = true
            errorMessage = "Please fix the errors above."
        }
    }
}
