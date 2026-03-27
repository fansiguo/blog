import Foundation
import Security

final class KeychainService {
    static let shared = KeychainService()
    private let tokenKey = "com.blog.jwt.token"
    private let nicknameKey = "com.blog.user.nickname"

    private init() {}

    func saveToken(_ token: String) {
        save(key: tokenKey, value: token)
    }

    func getToken() -> String? {
        load(key: tokenKey)
    }

    func saveNickname(_ nickname: String) {
        save(key: nicknameKey, value: nickname)
    }

    func getNickname() -> String? {
        load(key: nicknameKey)
    }

    func clearAll() {
        delete(key: tokenKey)
        delete(key: nicknameKey)
    }

    // MARK: - Private

    private func save(key: String, value: String) {
        let data = Data(value.utf8)
        delete(key: key)
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        SecItemAdd(query as CFDictionary, nil)
    }

    private func load(key: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        guard status == errSecSuccess, let data = result as? Data else { return nil }
        return String(data: data, encoding: .utf8)
    }

    private func delete(key: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        SecItemDelete(query as CFDictionary)
    }
}
