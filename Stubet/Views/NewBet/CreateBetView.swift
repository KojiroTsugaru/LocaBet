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
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Form {
                    Section(header: Text("誰にベットする？")) {
                        Picker("名前", selection: $newBetData.selectedFriend) {
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
                                selection: $newBetData.date,
                                displayedComponents: .date
                            )
                            .labelsHidden()
                            .accentColor(
                                .orange
                            ) // Change the accent color for the date picker
                            Image(systemName: "calendar")
                                .foregroundColor(.gray)
                        }.padding(.vertical)
                    }
                    
                    Section(header: Text("時間を選択")) {
                        HStack {
                            DatePicker(
                                "",
                                selection: $newBetData.time,
                                displayedComponents: .hourAndMinute
                            )
                            .labelsHidden()
                            .accentColor(
                                .orange
                            ) // Change the accent color for the time picker
                            Image(systemName: "clock")
                                .foregroundColor(.gray)
                        }.padding(.vertical)
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
                    Text("戻る")
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
                })
        }
    }
    
    // フォームが有効かどうかの判定
    private var isFormValid: Bool {
        newBetData.selectedFriend != nil && !newBetData.title.isEmpty && !newBetData.description.isEmpty
    }
}

