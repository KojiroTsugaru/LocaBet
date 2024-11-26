//
//  FriendCell.swift
//  Stubet
//
//  Created by KJ on 11/26/24.
//

import SwiftUI

struct FriendCell: View {
    
    @StateObject private var friendManager = FriendManager.shared
    let friend: Friend
    
    var body: some View {
        HStack {
            Image(systemName: "person.crop.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 40, height: 40)
                .foregroundColor(Color.orange)
                .background(Circle().fill(Color.white)) // White outline
                .clipShape(Circle()) // Clip to circle
            VStack(alignment: .leading) {
                Text(friend.displayName)
                Text("@\(friend.userName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            Spacer()
            Button(
                action: {
                    friendManager
                        .removeFriend(
                            friendId: friend.id
                        ) { result in
                            switch result {
                            case .success:
                                print("フレンドを解除しました")
                            case .failure(let error):
                                print(
                                    "フレンド解除に失敗しました: \(error.localizedDescription)"
                                )
                            }
                        }
                }) {
                    Text("フレンド解除")
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.red)
                        .cornerRadius(12)
                }
        }
    }
}

fileprivate let dummyFriend = Friend(id: "2525", data: [
    "userName": "johndoe",
    "displayName": "John Doe",
    "icon_url": "https://example.com/john.jpg"
])

#Preview {
    FriendCell(friend: dummyFriend)
}
