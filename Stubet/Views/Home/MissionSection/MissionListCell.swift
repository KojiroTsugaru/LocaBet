//
//  MissionRowView.swift
//  Stubet
//
//  Created by KJ on 9/3/24.
//

import SwiftUI

struct MissionListCell: View {
    
    @StateObject private var accountManager = AccountManager.shared
    
    var mission: Mission
    var isPendingStatus: Bool
    
    @State private var sender: User?
    
    init(mission: Mission) {
        self.mission = mission
        self.isPendingStatus = mission.status == .invitePending
    }
    
    var body: some View {
        NavigationLink(destination: MissionDetailsView(mission: mission)) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    // Mission Title
                    Text(mission.title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(
                            isPendingStatus ? Color.white : Color.primary
                        )
                    
                    // Time Remaining
                    Text(
                        mission.isDeadlinePassed ? mission.formattedDeadline : mission.deadlineTimeRemaining
                    )
                    .font(.subheadline)
                    .foregroundColor(
                        isPendingStatus ? Color.white : Color.secondary
                    )
                    
                    // Location and Distance
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.and.ellipse")
                        Text(mission.location.name)
                        
                        Spacer()
                        
                        // Profile Image of sender
                        AsyncImage(
                            url: URL(string: sender?.iconUrl ?? "")
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
                                .foregroundColor(
                                    isPendingStatus ? Color.white : Color.secondary
                                )
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
                        stops: [
                            .init(
                                color: Color(
                                    red: 1.00,
                                    green: 0.75,
                                    blue: 0.29
                                ),
                                location: 0.00
                            ),
                            .init(
                                color: Color(
                                    red: 1.00,
                                    green: 0.62,
                                    blue: 0.29
                                ),
                                location: 1.00
                            ),
                        ],
                        startPoint: UnitPoint(x: 1, y: 0),
                        endPoint: UnitPoint(x: 0, y: 1)
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
                    sender = try await accountManager
                        .fetchUser(id: mission.senderId)
                    print("fetch sender is called")
                } catch {
                    print("error fetching sender informatin: \(error)")
                }
            }
        }
        .padding(.horizontal)
    }
}
