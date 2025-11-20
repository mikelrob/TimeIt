// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "TimeIt",
    products: [
        .library(
            name: "TimeIt",
            targets: ["TimeIt"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "TimeIt",
            dependencies: [],
            resources: [.copy("TimeIt.docc")]),
        .testTarget(
            name: "TimeItTests",
            dependencies: ["TimeIt"]),
    ]
)
