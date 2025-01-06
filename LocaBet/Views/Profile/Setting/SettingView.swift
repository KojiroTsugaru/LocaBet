//
//  SettingView.swift
//  Stubet
//
//  Created by KJ on 11/18/24.
//

import SwiftUI

struct SettingView: View {
    @State private var showLogoutAlert = false
    @State private var showDeleteAlert = false
    @State private var showFinalDeleteAlert = false
    
    @ObservedObject private var viewModel = SettingViewModel()
    
    var body: some View {
        ZStack {
            VStack {
                Button {
                    showLogoutAlert = true
                } label: {
                    Text("サインアウト")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.vertical)
                
                Button {
                    showDeleteAlert = true
                } label: {
                    Text("アカウント削除")
                        .foregroundColor(.red)
                        .padding(8)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(8)
                }
                .padding(.vertical)
                Spacer()
            }
            
            if viewModel.isDeletingAccount {
                Color.black.opacity(0.5)
                    .edgesIgnoringSafeArea(.all)
                    .overlay(
                        VStack(spacing: 20) {
                            ProgressView("アカウント削除中...")
                                .progressViewStyle(
                                    CircularProgressViewStyle(tint: .white)
                                )
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    )
            }
        }
        .alert("サインアウト", isPresented: $showLogoutAlert, actions: {
            Button("キャンセル", role: .cancel) { }
            Button("サインアウト", role: .destructive) {
                Task {
                    try await viewModel.signout()
                }
            }
        }, message: {
            Text("本当にサインアウトしますか？")
        })
        .alert("アカウントを削除", isPresented: $showDeleteAlert, actions: {
            Button("キャンセル", role: .cancel) { }
            Button("削除する", role: .destructive) {
                showFinalDeleteAlert = true
            }
        }, message: {
            Text("アカウントを削除すると元に戻せません。本当に削除しますか？")
        })
        .alert("最終確認", isPresented: $showFinalDeleteAlert, actions: {
            Button("キャンセル", role: .cancel) { }
            Button("完全に削除する", role: .destructive) {
                Task {
                    try await viewModel.deleteAccount()
                }
            }
        }, message: {
            Text("本当にアカウントを完全に削除しますか？")
        })
        .navigationTitle("設定")
    }
}

#Preview {
    SettingView()
}
