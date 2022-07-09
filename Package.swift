// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    
    name: "Lister",
    
    platforms: [
        .iOS(.v13)
    ],
    
    products: [
        
        .library(
            name: "Lister",
            targets: ["Lister"]),
    ],
    
    targets: [
        .target(
            name: "Lister",
            dependencies: []),
        .testTarget(
            name: "ListerTests",
            dependencies: ["Lister"]),
    ]
)
