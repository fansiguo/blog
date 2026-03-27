import Foundation
import SwiftUI

@MainActor
final class AuthViewModel: ObservableObject {
    @Published var isLoggedIn: Bool = false
    @Published var nickname: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    init() {
        isLoggedIn = KeychainService.shared.getToken() != nil
        nickname = KeychainService.shared.getNickname() ?? ""

        APIClient.shared.onUnauthorized = { [weak self] in
            Task { @MainActor in
                self?.logout()
            }
        }
    }

    func login(username: String, password: String) async {
        isLoading = true
        errorMessage = nil

        do {
            let response: LoginResponse = try await APIClient.shared.request(
                .login,
                body: LoginRequest(username: username, password: password)
            )
            KeychainService.shared.saveToken(response.token)
            KeychainService.shared.saveNickname(response.nickname)
            nickname = response.nickname
            isLoggedIn = true
        } catch let error as APIError {
            errorMessage = error.errorDescription
        } catch {
            errorMessage = "登录失败: \(error.localizedDescription)"
        }

        isLoading = false
    }

    func logout() {
        KeychainService.shared.clearAll()
        isLoggedIn = false
        nickname = ""
    }
}
