// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "DJRangeSlider",
    platforms: [
            .iOS(.v13),
        ],
    products: [
        .library(
            name: "DJRangeSlider",
            targets: ["DJRangeSlider"]),
    ],
    targets: [
        .target(
            name: "DJRangeSlider"),
    ]
)
