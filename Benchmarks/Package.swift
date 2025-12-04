// swift-tools-version:5.10

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
  name: "benchmarks",
  platforms: [
    .macOS("14")
  ],
  dependencies: [
    .package(path: "../"),
    .package(url: "https://github.com/ordo-one/package-benchmark.git", from: "1.22.0"),
  ],
  targets: [
    .executableTarget(
      name: "NIOAsyncRuntimeBenchmarks",
      dependencies: [
        .product(name: "Benchmark", package: "package-benchmark"),
        .product(name: "NIOAsyncRuntime", package: "nio-async-runtime"),
      ],
      path: "Benchmarks/NIOAsyncRuntimeBenchmarks",
      plugins: [
        .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
      ]
    )
  ]
)
