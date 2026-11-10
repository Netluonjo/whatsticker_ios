// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "WhatStickeriOS",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "WhatStickeriOS",
            targets: ["WhatStickeriOS"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WhatStickeriOS",
            path: "WhatStickeriOS"
        ),
    ]
)
