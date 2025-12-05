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

// NOTE: By and large the benchmarks here were ported from swift-nio
// to allow side-by-side performance comparison
//
// See https://github.com/apple/swift-nio/blob/main/Benchmarks/Benchmarks/NIOPosixBenchmarks/Benchmarks.swift

import Benchmark
import NIOCore
import NIOEmbedded

let benchmarks = {
    let defaultMetrics: [BenchmarkMetric] = [
        .mallocCountTotal
    ]

    let leakMetrics: [BenchmarkMetric] = [
        .mallocCountTotal,
        .memoryLeaked,
    ]

    Benchmark(
        "NIOAsyncChannel.init",
        configuration: .init(
            metrics: defaultMetrics,
            scalingFactor: .kilo,
            maxDuration: .seconds(10_000_000),
            maxIterations: 10
        )
    ) { benchmark in
        // Elide the cost of the 'EmbeddedChannel'. It's only used for its pipeline.
        var channels: [EmbeddedChannel] = []
        channels.reserveCapacity(benchmark.scaledIterations.count)
        for _ in 0 ..< benchmark.scaledIterations.count {
            channels.append(EmbeddedChannel())
        }

        benchmark.startMeasurement()
        defer {
            benchmark.stopMeasurement()
        }
        for channel in channels {
            let asyncChanel = try NIOAsyncChannel<ByteBuffer, ByteBuffer>(
                wrappingChannelSynchronously: channel)
            blackHole(asyncChanel)
        }
    }

    Benchmark(
        "WaitOnPromise",
        configuration: .init(
            metrics: leakMetrics,
            scalingFactor: .kilo,
            maxDuration: .seconds(10_000_000),
            maxIterations: 10_000 // need 10k to get a signal
        )
    ) { benchmark in
        // Elide the cost of the 'EmbeddedEventLoop'.
        let el = EmbeddedEventLoop()

        benchmark.startMeasurement()
        defer {
            benchmark.stopMeasurement()
        }

        for _ in 0 ..< benchmark.scaledIterations.count {
            let p = el.makePromise(of: Int.self)
            p.succeed(0)
            do { _ = try! p.futureResult.wait() }
        }
    }
}
