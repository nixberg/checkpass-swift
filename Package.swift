// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "checkpass-swift",
    products: [
        .executable(
            name: "checkpass",
            targets: ["Checkpass"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.0.0"),
        .package(url: "https://github.com/nixberg/sha1-swift", from: "0.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "Checkpass",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "SHA1", package: "sha1-swift"),
            ],
            swiftSettings: [
                .unsafeFlags(["-parse-as-library"]) // https://bugs.swift.org/browse/SR-12683
            ]),
    ]
)
