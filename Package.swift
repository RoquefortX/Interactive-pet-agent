// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "InteractivePetAgent",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "InteractivePetAgent",
            targets: ["InteractivePetAgent"]
        )
    ],
    targets: [
        .executableTarget(
            name: "InteractivePetAgent",
            path: "InteractivePetAgent/Sources"
        ),
        .testTarget(
            name: "InteractivePetAgentTests",
            dependencies: ["InteractivePetAgent"],
            path: "InteractivePetAgent/Tests"
        )
    ]
)
