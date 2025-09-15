// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "numbers",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "numbers",
            targets: ["numbers"]),
        .library(
            name: "numbers_recursive",
            targets: ["numbers_recursive"]
        ),
        .library(
            name: "numbers_iterative",
            targets: ["numbers_iterative"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "numbers"),
        .target(
            name: "numbers_recursive"),
        .target(
            name: "numbers_iterative"
        ),
        .testTarget(
            name: "numbersTests",
            dependencies: ["numbers"]),
        .testTarget(
            name: "numbers_recursive_test",
            dependencies: ["numbers_recursive"]
        ),
        .testTarget(
            name: "numbers_iterative_test",
            dependencies: ["numbers_iterative"]
        ),
    ]
)
