// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "checkpass",
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "0.1.0"),
        .package(name: "SHA1", url: "https://github.com/nixberg/sha1-swift", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "checkpass",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SHA1", package: "SHA1")
            ]
        )
    ]
)
