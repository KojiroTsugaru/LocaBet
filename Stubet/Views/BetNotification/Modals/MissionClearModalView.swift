//
//  MissionClearModalView.swift
//  Stubet
//
//  Created by KJ on 11/9/24.
//

import SwiftUI

struct MissionClearModalView: View {
    
    @Environment(\.dismiss) var dismissModal
    
    @ObservedObject var viewModel: ModalViewModel
    @State private var mission: Mission?
    @State private var missionSender: User?
    let missionId: String
    let dismiss: () -> Void
    
    init(missionId: String, dismiss: @escaping () -> Void) {
        self.missionId = missionId
        self.viewModel = ModalViewModel(betId: missionId)
        self.dismiss = dismiss
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("ミッションをクリアしました🎉")
                .font(.title2)
                .bold()
            Text("ベットされた相手: \(viewModel.opponent?.displayName ?? "")")
            Text("目的地: \(viewModel.betItem?.location.name ?? "")")
            Text("ベット内容:\n\(viewModel.betItem?.description ?? "")")
            

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
        .interactiveDismissDisabled()
    }
}

//#Preview {
//    MissionClearModalView(regionIdentifier: "Test Location")
//}
