
import Foundation
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var showSignupView = false // サインアップ画面表示フラグ
    
    init(){
        self.viewModel = LoginViewModel()
    }
    
    var body: some View {
        if showSignupView {
            SignupView(showSignupView: $showSignupView)
        } else {
            ZStack {
                loginContent
                
                // Show loading overlay
                if viewModel.isLoading {
                    loadingOverlay
                }
            }
        }
    }

    private var loginContent: some View {
        VStack {
            Spacer()

            // ロゴとテキストをVStackでまとめ、上部に配置
            VStack {
                // ロゴ部分（必要に応じて画像を追加）
                Image("ハッカソンロゴ02")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 210, height: 210)
            }
            .padding()

            Spacer()

            // ユーザー名入力フィールド
            TextField("ユーザー名", text: $viewModel.userName)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .padding(.horizontal)

            // パスワード入力フィールド
            SecureField("パスワード", text: $viewModel.password)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray, lineWidth: 0.5)
                )
                .padding(.horizontal)

            // ログインボタン
            Button {
                Task {
                    await viewModel.signIn()
                }
            } label: {
                Text("ログイン")
                    .foregroundColor(.white)
                    .bold()
                    .padding()
                    .background(.orange)
                    .cornerRadius(12)
            }
            .padding()

            if let errorMessage = viewModel.errorMessage {
                Text("エラー: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            }
            
            // サインアップへの案内とボタン
            HStack {
                Text("アカウントをお持ちでないですか？")
                Button("新規登録") {
                    showSignupView = true
                }
            }
            .padding()

            Spacer()
        }
        .padding()
    }
    
    private var loadingOverlay: some View {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
            .overlay(
                VStack(spacing: 20) {
                    ProgressView("ログイン中...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .foregroundColor(.white)
                        .font(.headline)
                }
            )
    }
}
