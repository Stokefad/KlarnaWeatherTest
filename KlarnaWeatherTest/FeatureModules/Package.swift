// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FeatureModules",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "FeatureModules",
            targets: ["WeatherMain", "WeatherSearch", "WeatherCoordinator", "SharedModels", "Utils", "AppCoordinator"]),
    ],
    dependencies: [
        .package(path: "./UIComponentsLibrary"),
        .package(path: "./BusinessLogic")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WeatherMain",
            dependencies: ["UIComponentsLibrary", "SharedModels"]),
        .target(
            name: "WeatherSearch",
            dependencies: ["UIComponentsLibrary", "SharedModels"]),
        .target(
            name: "WeatherCoordinator",
            dependencies: ["WeatherMain", "WeatherSearch"]),
        .target(
            name: "SharedModels",
            dependencies: []),
        .target(
            name: "Utils",
            dependencies: []),
        .target(
            name: "AppCoordinator",
            dependencies: []),
        .testTarget(
            name: "FeatureModulesTests",
            dependencies: []),
    ]
)
