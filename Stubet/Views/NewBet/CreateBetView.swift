//
//  CreateBetView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/04.
//

import SwiftUI

struct CreateBetView: View {
    @StateObject var newBetData = NewBetData()
    @Environment(\.presentationMode) var presentationMode
    @Binding var showNewBetModal: Bool // Accept showNewBet as a Binding
    
    let sampleFriends = [
        Friend(id: "1", data: [
            "userName": "johndoe",
            "displayName": "John Doe",
            "icon_url": "https://example.com/john.jpg"
        ]),
        Friend(id: "2", data: [
            "userName": "janedoe",
            "displayName": "Jane Doe",
            "icon_url": "https://example.com/jane.jpg"
        ]),
    ]
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Form {
                    Section(header: Text("誰にベットする？")) {
                        Picker("名前", selection: $newBetData.selectedFriend) {
                            Text("選択してください").tag(nil as Friend?)
                            ForEach(sampleFriends) { friend in
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
                    TimeSettingView(
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

//struct CreateBetView_Previews: PreviewProvider {
//    static var previews: some View {
//        let sampleFriends = [
//            Friend(id: "1", data: [
//                "userName": "johndoe",
//                "displayName": "John Doe",
//                "icon_url": "https://example.com/john.jpg"
//            ]),
//            Friend(id: "2", data: [
//                "userName": "janedoe",
//                "displayName": "Jane Doe",
//                "icon_url": "https://example.com/jane.jpg"
//            ]),
//            Friend(id: "3", data: [
//                "userName": "bobsmith",
//                "displayName": "Bob Smith",
//                "icon_url": "https://example.com/bob.jpg"
//            ])
//        ]
//
//        let viewModel = NewBetViewModel()
//        viewModel.friends = sampleFriends
//        viewModel.selectedFriend = sampleFriends.first
//        viewModel.title = "サンプルベット"
//        viewModel.description = "これはサンプルのベット内容です。友人と楽しく賭けましょう！"
//
//        return NavigationView {
//            NewBetView()
//        }
//    }
//}
