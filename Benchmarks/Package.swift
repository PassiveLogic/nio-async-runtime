// swift-tools-version:5.10

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
