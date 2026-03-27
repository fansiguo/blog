import Foundation

enum AppConfig {
    // 设置为 Mac 的 WiFi IP，真机和 Mac 需在同一局域网
    static let baseURL = "http://192.168.1.107:8080"
    static let apiBaseURL = "\(baseURL)/api"
    static let pageSize = 10
    static let maxPageSize = 100
}
