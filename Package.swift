// swift-tools-version: 6.0
//===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 PassiveLogic, Inc.
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
//
// SPDX-License-Identifier: Apache-2.0
//
//===----------------------------------------------------------------------===//

import PackageDescription

let package = Package(
    name: "nio-async-runtime",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
        .watchOS(.v9),
        .tvOS(.v16),
    ],
    products: [
        .library(
            name: "NIOAsyncRuntime",
            targets: ["NIOAsyncRuntime"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-atomics.git", from: "1.1.0"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.89.0"),
    ],
    targets: [
        .target(
            name: "NIOAsyncRuntime",
            dependencies: [
                .product(name: "Atomics", package: "swift-atomics"),
                .product(name: "NIOCore", package: "swift-nio"),
            ]
        ),
        .executableTarget(
            name: "ExampleMTELG",
            dependencies: [.target(name: "NIOAsyncRuntime")]
        ),
        .executableTarget(
            name: "ExampleNIOThreadPool",
            dependencies: [.target(name: "NIOAsyncRuntime")]
        ),
        .testTarget(
            name: "NIOAsyncRuntimeTests",
            dependencies: [
                "NIOAsyncRuntime",
                .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
                .product(name: "NIOCore", package: "swift-nio"),
                .product(name: "NIOFoundationCompat", package: "swift-nio"),
                .product(name: "NIOTestUtils", package: "swift-nio"),
            ]
        ),
    ]
)
