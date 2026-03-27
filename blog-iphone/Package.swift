// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "BlogApp",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "BlogApp", targets: ["BlogApp"])
    ],
    targets: [
        .target(
            name: "BlogApp",
            path: "BlogApp"
        )
    ]
)
