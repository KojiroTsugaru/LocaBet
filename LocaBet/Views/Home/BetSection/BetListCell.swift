//
//  BetRowView.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import SwiftUI

struct BetListCell: View {
    
    @StateObject private var accountManager = AccountManager.shared
    
    let bet: Bet
    var isPendingStatus: Bool
    
    @State private var receiver: User?
    
    init(bet: Bet) {
        self.bet = bet
        self.isPendingStatus = bet.status == .rewardPending
    }
    
    var body: some View {
        NavigationLink(destination: BetDetailsView(bet: bet)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Mission Title
                    Text(bet.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(
                            isPendingStatus ? Color.white : Color.primary
                        )
                    
                    // Deadline
                    Text(
                        bet.isDeadlinePassed ? bet.formattedDeadline : bet.deadlineTimeRemaining
                    )
                    .font(.subheadline)
                    .foregroundColor(
                        isPendingStatus ? Color.white : Color.secondary
                    )
                    
                    
                    // Location and Distance
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(bet.location.name)
                        
                        Spacer()
                        
                        // Profile Image of sender
                        AsyncImage(
                            url: URL(string: receiver?.iconUrl ?? "")
                        ) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 30, height: 30)
                                .foregroundColor(.gray)
                                .clipShape(Circle())
                        }
                    }
                    .font(.caption)
                    .foregroundColor(
                        isPendingStatus ? Color.white : Color.secondary
                    )
                }
            }
            .padding()
            .background(
                isPendingStatus ?
                AnyView(
                    LinearGradient(
                        gradient: Gradient(
                            stops: [
                                .init(
                                    color: Color(
                                        red: 1.00,
                                        green: 0.50,
                                        blue: 0.29
                                    ),
                                    location: 0.0
                                ),
                                // Darker orange
                                .init(
                                    color: Color(
                                        red: 1.00,
                                        green: 0.65,
                                        blue: 0.29
                                    ),
                                    location: 1.0
                                ),
                                // Lighter orange
                            ]
                        ),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                : AnyView(Color(UIColor.systemBackground))
            )
            .cornerRadius(10)
            .shadow(radius: 2)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(
                        isPendingStatus ? Color.orange
                            .opacity(0) : Color.gray
                            .opacity(0.2),
                        lineWidth: 1
                    )
            )
            .task {
                do {
                    receiver = try await accountManager
                        .fetchUser(id: bet.receiverId)
                } catch {
                    print("error fetching sender informatin: \(error)")
                }
            }
        }.padding(.horizontal)
    }
}
