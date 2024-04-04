// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "RomanizedText",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "RomanizedText",
            targets: ["RomanizedText"]),
        .executable(name: "unromanize", targets: ["Unromanize"])
    ],
//    dependencies: [
//        .package(url: "https://github.com/rwtodd/ArgParser.git", from: "1.1.0")
//    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "RomanizedText"),
        .executableTarget(name: "Unromanize", dependencies: ["RomanizedText"]),
        .testTarget(
            name: "RomanizedTests",
            dependencies: ["RomanizedText"]),
    ]
)
