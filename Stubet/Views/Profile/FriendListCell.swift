//
//  FriendListCell.swift
//  Stubet
//
//  Created by KJ on 11/18/24.
//

import SwiftUI

struct FriendListCell: View {
    
    let user: Friend
    
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
                Text(user.displayName)
                Text("@\(user.userName)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    FriendListCell()
//}
