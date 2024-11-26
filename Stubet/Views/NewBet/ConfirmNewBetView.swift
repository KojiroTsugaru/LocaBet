//
//  ConfirmNewBetView.swift
//  Stubet
//
//  Created by KJ on 9/5/24.
//

import SwiftUI
import FirebaseFirestore
import CoreLocation

struct ConfirmNewBetView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var newBetData: NewBetData
    @Binding var showNewBetModal: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                // Bet Content Section
                VStack(alignment: .leading, spacing: 10) {

                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .foregroundColor(.orange)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())

                        VStack(alignment: .leading) {
                            Text(newBetData.selectedFriend.displayName)
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Text(newBetData.title)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                    }

                    Text(newBetData.description)
                        .font(.body)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                }
                .padding()

                // Location&Time
                EventView()
            }
            .padding()
        }
        .navigationTitle("ベット確認")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(trailing: Button(action: {
            Task.init {
                await BetManager.shared.createBet(newBetData: newBetData)
            }
             // Dismiss the current view
            showNewBetModal = false
            
        }) {
            Text("作成する")
        })
    }
    }

fileprivate let dummyFriend = Friend(
    id: "friend001",
    data: [
        "userName": "john_doe",
        "displayName": "John Doe",
        "addedAt": Timestamp(date: Date()), // 現在の日時
        "iconUrl": "https://example.com/user_icon/johndoe.png"
    ]
)

fileprivate let dummyNewBetData = NewBetData(
    selectedFriend: dummyFriend,
    title: "5K Run Bet",
    description: "Let's see who can finish a 5K run faster!",
    date: Calendar.current.date(byAdding: .day, value: 10, to: Date()) ?? Date(), // 10 days from now
    time: Calendar.current.date(bySettingHour: 8, minute: 30, second: 0, of: Date()) ?? Date(), // 8:30 AM
    locationName: "Greenwood Park",
    selectedCoordinates: CLLocationCoordinate2D(latitude: 34.052235, longitude: -118.243683) // Los Angeles
)

#Preview {
    ConfirmNewBetView(newBetData: dummyNewBetData, showNewBetModal: Binding.constant(true))
}
