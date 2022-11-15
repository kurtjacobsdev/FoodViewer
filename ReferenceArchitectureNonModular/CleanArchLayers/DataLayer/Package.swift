// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DataLayer",
    platforms: [.iOS(.v14)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DataLayer",
            targets: ["DataLayer"]
        )
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(path: "DomainLayer")
    ],
    targets: [
        .target(
            name: "DataLayer",
            dependencies: [
                "DomainLayer"
            ]
        ),
        .testTarget(
            name: "DataLayerTests",
            dependencies: [
                "DomainLayer"
            ]
        )
    ]
)
