// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TestingLayer",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "TestingLayer",
            targets: ["TestingLayer"]
        )
    ],
    dependencies: [
        .package(path: "DataLayer"),
        .package(path: "DomainLayer"),
        .package(path: "UILayer"),
        .package(url: "https://github.com/WeTransfer/Mocker", from: "3.0.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.10.0")
    ],
    targets: [
        .target(
            name: "TestingLayer",
            dependencies: [
                "DataLayer",
                "DomainLayer",
                "UILayer",
                "Mocker"
            ]
        ),
        .testTarget(
            name: "TestingLayerTests",
            dependencies: [
                "TestingLayer",
                "DataLayer",
                "DomainLayer",
                "UILayer",
                "Mocker",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
