// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "checkpass",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.3.1"),
        .package(url: "https://github.com/nixberg/sha1-swift", from: "0.2.0")
    ],
    targets: [
        .target(
            name: "checkpass",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SHA1", package: "sha1-swift")
            ])
    ]
)
