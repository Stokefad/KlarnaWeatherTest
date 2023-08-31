// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WeatherStory",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "WeatherStory",
            targets: ["WeatherMain", "WeatherSearch", "WeatherCoordinator", "SharedModels"]),
    ],
    dependencies: [
        .package(path: "../UIComponents"),
        .package(path: "../DataProviders")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "WeatherMain",
            dependencies: ["UIComponents", "WeatherDataProvider", "TemperatureUnitPickedService", "SharedModels"]),
        .target(
            name: "WeatherSearch",
            dependencies: ["UIComponents", "SharedModels"]),
        .target(
            name: "WeatherCoordinator",
            dependencies: ["WeatherMain", "WeatherSearch"]),
        .target(
            name: "SharedModels",
            dependencies: []),
        .testTarget(
            name: "WeatherStoryTests",
            dependencies: []),
    ]
)
