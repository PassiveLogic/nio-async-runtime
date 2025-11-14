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
    products: [
        .library(
            name: "NIOAsyncRuntime",
            targets: ["NIOAsyncRuntime"]
        ),
    ],
    targets: [
        .target(
            name: "NIOAsyncRuntime"
        ),
        .testTarget(
            name: "NIOAsyncRuntimeTests",
            dependencies: ["NIOAsyncRuntime"]
        ),
    ]
)
