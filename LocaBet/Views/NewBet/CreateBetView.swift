//
//  CreateBetView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/04.
//

import SwiftUI

struct CreateBetView: View {
    @StateObject var newBetData = NewBetData(title: "", description: "", locationName: "")
    @StateObject private var friendManager = FriendManager.shared
    @Environment(\.presentationMode) var presentationMode
    @Binding var showNewBetModal: Bool // Accept showNewBet as a Binding
    @State private var errorMessage: String?
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Form {
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .font(.caption)
                            .foregroundColor(.red)
                    }
                    Section(header: Text("誰にベットする？")) {
                        Picker(newBetData.selectedFriend?.displayName ?? "フレンド選択", selection: $newBetData.selectedFriend) {
                            Text("選択してください").tag(nil as Friend?)
                            ForEach(friendManager.friends) { friend in
                                Text(friend.displayName).tag(friend as Friend?)
                            }
                        }
                    }
                    
                    Section(header: Text("タイトル")) {
                        TextField("タイトル", text: $newBetData.title)
                    }
                    
                    Section(header: Text("ベット内容")) {
                        TextEditor(text: $newBetData.description)
                            .frame(height: 100)
                    }
                    
                    Section(header: Text("日付を選択")) {
                        HStack {
                            DatePicker(
                                "",
                                selection: $newBetData.deadline,
                                in: Date()...,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .accentColor(
                                .orange
                            ) // Change the accent color for the date picker
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                        }.padding(.vertical, 2)
                    }
                    
                    Section(header: Text("時間を選択")) {
                        HStack {
                            DatePicker(
                                "",
                                selection: $newBetData.deadline,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .accentColor(
                                .orange
                            ) // Change the accent color for the time picker
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                        }.padding(.vertical, 2)
                    }
                    
                }
            }
            .task {
                do {
                    try await friendManager.fetchFriends()
                } catch {
                    print(
                        "Error loading friends: \(error.localizedDescription)"
                    )
                }
            }
            .navigationTitle("ベット作成")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("閉じる")
                        .foregroundColor(Color.orange)
                }),
                trailing: NavigationLink {
                    SetLocationView(
                        newBetData: newBetData,
                        showNewBetModal: $showNewBetModal
                    )
                } label: {
                    Text("次へ")
                        .foregroundColor(Color.orange)
                }
                .disabled(!isFormValid)
                .onTapGesture {
                    if !isFormValid {
                        errorMessage = "フォームにすべての入力項目を記入してください。"
                    }
                }
            )
        }
    }
    
    // フォームが有効かどうかの判定
    private var isFormValid: Bool {
        (newBetData.selectedFriend != nil) && !newBetData.title.isEmpty && !newBetData.description.isEmpty
    }
}

