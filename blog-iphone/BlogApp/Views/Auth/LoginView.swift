import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var username = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            // Icon
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color.blogPrimaryLight)
                    .frame(width: 56, height: 56)
                Image(systemName: "lock.fill")
                    .font(.system(size: 24))
                    .foregroundColor(.blogPrimary)
            }

            VStack(spacing: 6) {
                Text("Welcome Back")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(.blogText)
                Text("登录管理后台")
                    .font(.blogBody)
                    .foregroundColor(.blogTextSecondary)
            }

            VStack(spacing: 16) {
                if let error = authViewModel.errorMessage {
                    Text(error)
                        .font(.blogCaption)
                        .foregroundColor(.blogDanger)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: "#fef2f2"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color(hex: "#fecaca"), lineWidth: 1)
                        )
                        .cornerRadius(8)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("用户名")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blogText)
                    TextField("请输入用户名", text: $username)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.username)
                        .autocapitalization(.none)
                }

                VStack(alignment: .leading, spacing: 6) {
                    Text("密码")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.blogText)
                    SecureField("请输入密码", text: $password)
                        .textFieldStyle(.roundedBorder)
                        .textContentType(.password)
                }

                Button {
                    Task {
                        await authViewModel.login(username: username, password: password)
                    }
                } label: {
                    if authViewModel.isLoading {
                        ProgressView()
                            .tint(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                    } else {
                        Text("登录")
                            .font(.system(size: 15, weight: .semibold))
                            .frame(maxWidth: .infinity)
                            .frame(height: 20)
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.blogPrimary)
                .disabled(username.isEmpty || password.isEmpty || authViewModel.isLoading)
            }
            .padding(24)
            .background(Color.blogSurface)
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.08), radius: 20, y: 8)

            Spacer()
            Spacer()
        }
        .padding(.horizontal, 32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.blogBackground)
        .toolbarBackground(Color.blogBackground, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
