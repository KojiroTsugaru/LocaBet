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
    @Published var email = ""
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
    
    // バリデーションロジックを含むメソッド
    func validateFields() {
        // テキストボックスが空かどうか
        usernameError = username.isEmpty ? "Username is required." : ""
        emailError = email.isEmpty ? "Email is required." : ""
        passwordError = password.isEmpty ? "Password is required." : ""
        confirmPasswordError = confirmPassword.isEmpty ? "Confirmation is required." : ""

        // username条件
        
        // email条件
        
        // password条件
        passwordError = (password.count < 8) ? "Password length error" : ""
        
        // confirmPassword条件
        if password != confirmPassword{
            confirmPasswordError = "Password not match"
        }
        
        
    }
        
    func signup() {
        validateFields()

        // エラーがなければ続行
        if usernameError.isEmpty && emailError.isEmpty && passwordError.isEmpty && confirmPasswordError.isEmpty {
           
            // TODO：ユーザーの詳細入力に進む
            
            
            
        } else {
            showError = true
            errorMessage = "Please fix the errors above."
        }
    }
}
