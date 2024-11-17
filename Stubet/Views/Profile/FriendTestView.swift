//
//  FriendTestView.swift
//  Stubet
//
//  Created by KJ on 11/16/24.
//

import SwiftUI

//struct AddFriendView: View {
//    @State private var userName: String = ""
//    @State private var errorMessage: String?
//    @EnvironmentObject private var friendManager: FriendManager
//
//    var body: some View {
//        VStack {
//            TextField("Enter friend's username", text: $userName)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//
//            Button("Add Friend") {
//                friendManager.addFriend { result in
//                    switch result {
//                    case .success:
//                        errorMessage = nil
//                        print("Friend added successfully!")
//                    case .failure(let error):
//                        errorMessage = error.localizedDescription
//                    }
//                }
//            }
//            .padding()
//            
//            if let errorMessage = errorMessage {
//                Text("Error: \(errorMessage)")
//                    .foregroundColor(.red)
//                    .padding()
//            }
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    AddFriendView()
//}
