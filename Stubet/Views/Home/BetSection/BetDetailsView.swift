//
//  BetDetailsView.swift
//  Stubet
//
//  Created by KJ on 9/5/24.
//

import SwiftUI
import FirebaseFirestore

struct BetDetailsView: View {
    
    let bet: Bet
    
    @StateObject private var viewModel = BetDetailsViewModel()
    @State private var showDeleteAlert = false
    @State private var receiver: User?
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            // Invite Response Buttons
            if bet.status == .rewardPending {
                Button(action: {
                    // 報酬を受け取ったアクション
                    Task {
                        await viewModel
                            .receiveBetReward(bet: bet)
                    }
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("報酬を受け取りました")
                        .frame(maxWidth: 24, maxHeight: 16)
                        .padding()
                        .background(Color.orange)
                        .foregroundColor(.white)
                        .cornerRadius(16)
                }
            }
            
            ScrollView {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        AsyncImage(
                            url: URL(string: receiver?.iconUrl ?? "")
                        ) { image in
                            image
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        } placeholder: {
                            Image(systemName: "person.circle")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .clipShape(Circle())
                        }

                        VStack(alignment: .leading) {
                            Text(receiver?.displayName ?? "")
                                .font(.subheadline)
                                .fontWeight(.medium)

                            Text(bet.title)
                                .font(.title2)
                                .fontWeight(.bold)
                        }
                        Spacer()
                        Text(
                            {
                                switch bet.status {
                                case .ongoing:
                                    return "進行中"
                                case .invitePending:
                                    return "許可待ち"
                                case .rewardPending:
                                    return "報酬待ち"
                                default:
                                    return ""
                                }
                            }()
                        )
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(8)
                        .background(
                            bet.status == .ongoing ? Color.orange : Color.red
                        )
                        .cornerRadius(12)
                    }
                    Text("ベット内容")
                        .font(.headline)
                    Text(bet.description)
                        .font(.body)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 1)

                    // Location&Time
                    VStack(alignment: .leading) {
                        Text("場所＆時間")
                            .font(.headline)
                        TimeLocationDetailsPanel(betItem: bet)
                    }
                }
                .padding()
            }
        }
        .task {
            do {
                receiver = try await AccountManager.shared
                    .fetchUser(id: bet.receiverId)
            } catch {
                print("error fething user data: ", error)
            }
        }
        .navigationTitle("ベット詳細")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarItems(
            trailing: Menu(content: {
                Button("ベットを削除する", action: {
                    showDeleteAlert = true
                })
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.title2)
            })
        )
        .alert("ベットを削除しますか？", isPresented: $showDeleteAlert) {
            Button("削除する", role: .destructive) {
                // Action to delete bet
                Task {
                    await viewModel.deleteBet(bet: bet)
                }
                presentationMode.wrappedValue.dismiss()
            }
            Button("キャンセル", role: .cancel) {
                // Action for cancel (optional)
            }
        } message: {
            Text("この操作は取り消せません。")
        }
    }
}
