//
//  ProfileEditView.swift
//  Stubet
//
//  Created by KJ on 12/11/24.
//

import SwiftUI

struct ProfileEditView: View {
    
    @ObservedObject private var viewModel = ProfileEditViewModel()
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .resizable()
                            .frame(width: 20, height: 20)
                            .foregroundColor(.orange)
                    }
                    
                    Spacer()
                }
                // アイコン画像の選択
                ProfileEditPhotoPicker(viewModel: viewModel)

                // ディスプレイ名入力フィールドとエラーメッセージ
                VStack(alignment: .leading, spacing: 5) {
                    TextField("名前", text: $viewModel.displayName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .padding(.horizontal)
                    
                    if viewModel.usernameError != "" {
                        Text(viewModel.usernameError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 16)
                    }
                }
                .padding(.bottom, 10) // 各フィールドの間に隙間を追加
                
                // ユーザー名入力フィールドとエラーメッセージ
                VStack(alignment: .leading, spacing: 5) {
                    TextField("ユーザーネーム", text: $viewModel.username)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray, lineWidth: 0.5)
                        )
                        .padding(.horizontal)
                    
                    if viewModel.usernameError != "" {
                        Text(viewModel.usernameError)
                            .font(.caption)
                            .foregroundColor(.red)
                            .padding(.leading, 16)
                    }
                }
                .padding(.bottom, 10) // 各フィールドの間に隙間を追加

                // 保存ボタン
                Button(action: {
                    Task {
                        await viewModel.checkUsernameAvailability()
                        try await viewModel.updateUser() // 変更をfireStoreに反映する
                        try await AccountManager.shared.fetchCurrentUser()
                        dismiss()
                    }
                }) {
                    HStack {
                        Text("保存")
                            .font(.headline)
                            .padding()
                    }.foregroundColor(.white)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [.orange, .red]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(8)
                    
                }
                .padding()

                Spacer() // 下部にスペースを作るために追加
            }
            .padding()
            
            // Overlay for ProgressView
            if viewModel.isLoading {
                Color.black.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                VStack {
                    ProgressView("保存中...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                        .background(Color.orange.opacity(0.8))
                        .cornerRadius(10)
                        .foregroundColor(.white)
                }
            }
        }
    }
}

#Preview {
    ProfileEditView()
}
