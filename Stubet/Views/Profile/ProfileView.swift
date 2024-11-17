//
//  ProfileView.swift
//  Stubet
//
//  Created by 木嶋陸 on 2024/09/06.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var accountManager: AccountManager
    @StateObject private var friendManager = FriendManager.shared
    
    @State private var selectedTab: Tab = .mission // Track the selected tab

    enum Tab {
        case mission
        case bet
    }
    
    var body: some View {
        VStack() {
            ZStack {
                // Top curved background
                CurvedBackground()
                    .fill(Color.orange)
                    .frame(height: 200)
                    .ignoresSafeArea(.all)
                Spacer()
                	
                VStack {
                    // Icons on top-right
                    HStack {
                        Spacer()
                        // Settings Icon
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.trailing, 16)
                    }
                    
                    Spacer()
                    
                    VStack {
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80)
                            .foregroundColor(Color.orange)
                            .background(Circle().fill(Color.white)) // White outline
                            .clipShape(Circle()) // Clip to circle
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 4) // White border
                            )
                        
                        // User Info
                        VStack(spacing: 4) {
                            Text(accountManager.currentUser?.displayName ?? "No user")
                                .font(.title2)
                                .bold()
                            HStack {
                                Text("@\(accountManager.currentUser?.userName ?? "No user")")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                    }.offset(y: 20)
                }
            }
            .frame(height: 200)
            .padding(.bottom, 40) // Space for the profile picture overlap
        
            HStack (spacing: 16) {
                
                NavigationLink {
                    FriendRequestsTest()
                } label: {
                    VStack {
                        Image(systemName: "person.2.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("0 フレンド")
                    }

                    .padding(12)
                    .background(.white) // Set background color
                    .foregroundColor(Color.orange) // Set text and icon color
                    .cornerRadius(12) // Optional: Add rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 12) // Match corner radius
                            .stroke(Color.gray, lineWidth: 0.5) // Thin stroke line
                            .frame(width: 120, height: 64)
                    )
                    .frame(width: 136, height: 64)
                }
                
                NavigationLink {
                    FriendRequestsTest()
                } label: {
                    VStack {
                        Image(systemName: "magnifyingglass.circle")
                            .resizable()
                            .frame(width: 24, height: 24)
                        Text("ユーザーを探す")
                            .font(.body)
                    }

                    .padding(12)
                    .background(.white) // Set background color
                    .foregroundColor(Color.orange) // Set text and icon color
                    .cornerRadius(12) // Optional: Add rounded corners
                    .overlay(
                        RoundedRectangle(cornerRadius: 12) // Match corner radius
                            .stroke(Color.gray, lineWidth: 0.5) // Thin stroke line
                            .frame(width: 120, height: 64)
                    )
                    .frame(width: 136, height: 64)
                }
                
            }.padding(.bottom, 16)
            
            HStack {
                Text("履歴")
                    .padding(.horizontal)
                    .bold()
                Spacer()
            }
            
            ProfileTabView(selectedTab: $selectedTab)
                .frame(height: 25)
                .padding()
            
            // Content depending on the selected tab
            ScrollView {
                if selectedTab == .mission {
                    MissionListView()
                } else {
                    BetListView()
                }
            }

            Spacer()
        }
        .edgesIgnoringSafeArea(.bottom)
        .background(Color(UIColor.systemGroupedBackground))
        .navigationBarTitleDisplayMode(.inline) // No visible title
    }
            
}


// MARK: - Custom Curved Background
struct CurvedBackground: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.7))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.7),
            control: CGPoint(x: rect.width / 2, y: rect.height * 1.1)
        )
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ProfileView()
        .environmentObject(AccountManager.shared)
}
