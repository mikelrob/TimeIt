// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "TimeIt",
    products: [
        .library(
            name: "TimeIt",
            targets: ["TimeIt"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "TimeIt",
            dependencies: []),
        .testTarget(
            name: "TimeItTests",
            dependencies: ["TimeIt"]),
    ]
)
