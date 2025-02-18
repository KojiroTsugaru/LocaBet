//
//  ProfileViewHeader.swift
//  Stubet
//
//  Created by KJ on 11/18/24.
//

import SwiftUI

struct ProfileViewHeader: View {
    
    @StateObject private var accountManager = AccountManager.shared
    @StateObject private var friendManager = FriendManager.shared
    
    @State private var showProfileEdit = false
    
    var body: some View { 
        ZStack {
            // Top curved background
            CurvedBackground()
                .fill(Color.orange)
            
            VStack {
                // Icons on top-right
                HStack {
                    Spacer()
                    // Settings Icon
                    NavigationLink {
                        SettingView()
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(.trailing, 16)
                    }
                }
                
                Spacer()
                
                VStack {
                    Menu {
                        Button(action: {
                            showProfileEdit = true
                        }) {
                            Text("プロフィールを編集")
                        }
                    } label: {
                        if let image = AccountManager.shared.currentUser?.iconImage {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle().fill(Color.white)
                                ) // White outline
                                .clipShape(Circle()) // Clip to circle
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.white,
                                            lineWidth: 4
                                        ) // White border
                                )
                        } else {
                            // Placeholder or fallback
                            Image(systemName: "person.crop.circle.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 80, height: 80)
                                .background(
                                    Circle().fill(Color.white)
                                ) // White outline
                                .foregroundColor(.gray)
                                .clipShape(Circle()) // Clip to circle
                                .overlay(
                                    Circle()
                                        .stroke(
                                            Color.white,
                                            lineWidth: 4
                                        ) // White border
                                )
                        }
                    }
                    
                    // User Info
                    VStack(spacing: 4) {
                        Text(
                            accountManager.currentUser?.displayName ?? "No user"
                        )
                        .font(.title2)
                        .bold()
                        HStack {
                            Text(
                                "@\(accountManager.currentUser?.userName ?? "No user")"
                            )
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        }
                    }
                }.offset(y: 20)
            }
        }
        .frame(height: 200)
        .padding(.bottom, 24) // Space for the profile picture overlap
        
        HStack(spacing: 16) { // Add spacing between rectangles
            NavigationLink {
                FriendListView()
            } label: {
                VStack {
                    ZStack {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 32, height: 32) // Icon size
                            .foregroundColor(Color.orange)
                    }.frame(width: 32, height: 32)
                    
                    Text("\(friendManager.friends.count) フレンド")
                        .font(.subheadline)
                        .foregroundColor(Color.orange)
                }
                .padding()
                .frame(width: 140, height: 80) // Adjust size of the rectangle
                .background(Color.white) // Background color
                .cornerRadius(12) // Rounded corners
                .shadow(
                    color: Color.gray.opacity(0.2),
                    radius: 4,
                    x: 0,
                    y: 2
                ) // Subtle shadow
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color.gray.opacity(0.4),
                            lineWidth: 1
                        ) // Thin border
                )
            }
            
            NavigationLink {
                SearchUserView()
            } label: {
                VStack {
                    ZStack {
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24) // Icon size
                            .foregroundColor(Color.orange)
                    }.frame(width: 32, height: 32)
                    
                    Text("ユーザーを探す")
                        .font(.subheadline)
                        .foregroundColor(Color.orange)
                }
                .padding()
                .frame(width: 140, height: 80) // Adjust size of the rectangle
                .background(Color.white) // Background color
                .cornerRadius(12) // Rounded corners
                .shadow(
                    color: Color.gray.opacity(0.2),
                    radius: 4,
                    x: 0,
                    y: 2
                ) // Subtle shadow
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(
                            Color.gray.opacity(0.4),
                            lineWidth: 1
                        ) // Thin border
                )
            }
        }
        .padding()
        .background(
            Color(UIColor.systemGroupedBackground)
        ) // Add subtle background
        .sheet(isPresented: $showProfileEdit) {
            ProfileEditView()
                .interactiveDismissDisabled(true)
        }
    }
}

// MARK: - Custom Curved Background
struct CurvedBackground: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: 0, y: rect.height * 0.4))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: rect.height * 0.4),
            control: CGPoint(x: rect.width / 2, y: rect.height * 0.8)
        )
        path.addLine(to: CGPoint(x: rect.width, y: 0))
        path.closeSubpath()
        return path
    }
}

#Preview {
    ProfileViewHeader()
}
