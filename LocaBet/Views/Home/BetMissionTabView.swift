//
//  HomeTabView.swift
//  Stubet
//
//  Created by KJ on 11/14/24.
//

import SwiftUI

struct BetMissionTabView: View {
    @Binding var selectedTab: HomeView.Tab

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                selectedTab = .mission
            }) {
                Text("ミッション")
                    .font(.system(size: 12))
                    .padding(10)
                    .background(
                        selectedTab == .mission ? Color.orange : Color.clear
                    )
                    .foregroundColor(
                        selectedTab == .mission ? .white : .gray
                    )
                    .cornerRadius(48)
            }
            Spacer()
            Button(action: {
                selectedTab = .bet
            }) {
                Text("ベット")
                    .font(.system(size: 12))
                    .padding(10)
                    .background(
                        selectedTab == .bet ? Color.orange : Color.clear
                    )
                    .foregroundColor(
                        selectedTab == .bet ? .white : .gray
                    )
                    .cornerRadius(48)
            }
            Spacer()
        }
        .padding(.bottom)
    }
}
