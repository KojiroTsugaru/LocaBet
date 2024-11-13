
import Foundation
import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @ObservedObject var viewModel: LoginViewModel
    @State private var showSignupView = false // サインアップ画面表示フラグ
    @State private var errorMessage: String?
    
    init(){
        self.viewModel = LoginViewModel()
    }
    
    var body: some View {
        if showSignupView {
            SignupView(showSignupView: $showSignupView)
        } else {
            loginContent
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
                Text("StuBet")
                    .font(.title)
                    .bold()
            }
            .padding()

            Spacer()

            // エラーメッセージ表示（viewModelから取得）
            if viewModel.showError {
                Text("Incorrect username or password")
                    .foregroundColor(.red)
                    .padding(.bottom)
            }

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
                Task.init {
                    do {
                        try await AccountManager.shared
                            .signIn(
                                userName: viewModel.userName,
                                password: viewModel.password
                            )
                    } catch {
                        errorMessage = error.localizedDescription
                    }
                }
            } label: {
                Text("ログイン")
            }
            .padding()

            if let errorMessage = errorMessage {
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
}
