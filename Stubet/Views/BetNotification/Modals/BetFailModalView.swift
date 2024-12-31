//
//  BetFailModalView.swift
//  Stubet
//
//  Created by KJ on 12/27/24.
//

import SwiftUI

struct BetFailModalView: View {
    
    @Environment(\.dismiss) var dismissModal
    
    @ObservedObject var viewModel: ModalViewModel
    @State private var bet: Bet?
    @State private var betReceiver: User?
    let betId: String
    let dismiss: () -> Void
    
    init(betId: String, dismiss: @escaping () -> Void) {
        self.betId = betId
        self.viewModel = ModalViewModel(betId: betId)
        self.dismiss = dismiss
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ベットに失敗しました😢")
                .font(.title2)
                .bold()
            
            Text("ベットした相手: \(viewModel.opponent?.displayName ?? "")")
            Text("目的地: \(bet?.location.name ?? "")")
            Text("ベット内容:\n\(bet?.description ?? "")")
            
            Button {
                dismiss()
                dismissModal()
            } label: {
                Text("閉じる")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(.orange)
                    .cornerRadius(12)
            }
        }
        .padding()
        .task {
            await viewModel.fetchData()
        }
    }
}

#Preview {
    BetFailModalView(betId: "zz0iSYW7SD8DWKHzVDU0", dismiss: {
        print("閉じる")
    })
}
