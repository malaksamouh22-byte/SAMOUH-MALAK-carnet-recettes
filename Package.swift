// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "SwiftApp",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "App", targets: ["App"])
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", from: "2.0.0"),
        .package(url: "https://github.com/stephencelis/SQLite.swift.git", from: "0.15.3"),
    ],
    targets: [
        .executableTarget(
            name: "App",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "SQLite", package: "SQLite.swift"),
            ],
            path: "Sources/App"
        )
    ]
)
