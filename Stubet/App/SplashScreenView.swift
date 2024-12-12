//
//  SplashView.swift
//  Stubet
//
//  Created by KJ on 12/11/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.white
                .ignoresSafeArea(.all)
            
            Image("Stubet-logo")
                .resizable()
                .frame(width: 150, height: 150)
        }
    }
}

#Preview {
    SplashScreenView()
}
