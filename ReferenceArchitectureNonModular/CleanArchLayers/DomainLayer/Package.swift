// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainLayer",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "DomainLayer",
            targets: ["DomainLayer"]
        )
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DomainLayer",
            dependencies: [
            ]
        ),
        .testTarget(
            name: "DomainLayerTests",
            dependencies: [
                "DomainLayer"
            ]
        )
    ]
)
