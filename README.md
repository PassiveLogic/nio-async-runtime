# NIOAsyncRuntime

NIOAsyncRuntime provides a lightweight implementation of `MultiThreadedEventLoopGroup` and `NIOThreadPool` that can be used as a drop-in
replacement for the original implementations in NIOPosix.

NIOAsyncRuntime is powered by Swift Concurrency and avoids low-level operating system C API calls. This enables
compiling to WebAssembly using the [Swift SDK for WebAssembly](https://www.swift.org/documentation/articles/wasm-getting-started.html)

## Highlights

- Drop-in `MultiThreadedEventLoopGroup` and `NIOThreadPool` implementations that enable avoiding `NIOPosix` dependencies.
- Uses Swift Concurrency tasks under the hood.
- Matches the existing NIOPosix APIs, making adoption straightforward.

## Known Limitations

- NIOPosix currently provides significantly faster performance in benchmarks for heavy-load event enqueuing. See the benchmarks below for details.

# Getting Started

## Requirements

- Swift 6.0 or later toolchain
- Any platform supporting Swift Concurrency
- Minimum supported platforms: macOS 13.0, iOS 16.0, watchOS 9.0, tvOS 16.0, WASI 0.1

## Swift Package Manager

### NIOAsyncRuntime + NIOPosix side-by-side
 
This is the preferred way to use NIOAsyncRuntime. Use NIOAsyncRuntime only for targets where NIOPosix is unsupported.

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/apple/swift-nio.git",
        from: "2.89.0"
    ),
    .package(
        url: "https://github.com/passivelogic/nio-async-runtime.git",
        from: "0.0.1"
    ),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            // WASI targets use NIOAsyncRuntime
            .product(
                name: "NIOAsyncRuntime",
                package: "nio-async-runtime",
                condition: .when(platforms: [.wasi])
            ),

            // All other targets use NIOPosix
            .product(
                name: "NIOPosix",
                package: "swift-nio",
                condition: .when(platforms: [.macOS, .linux, .iOS])
            ),
        ]
    ),
]
```

### NIOAsyncRuntime standalone, no NIOPosix

Add the package to your `Package.swift`:

```swift
dependencies: [
    .package(
        url: "https://github.com/passivelogic/nio-async-runtime.git",
        from: "0.0.1"
    ),
],
targets: [
    .target(
        name: "YourTarget",
        dependencies: [
            .product(name: "NIOAsyncRuntime", package: "nio-async-runtime")
        ]
    ),
]
```

## Importing

You can opt in to the async runtime or fall back to `NIOPosix` with a simple conditional import.

```swift
#if canImport(NIOAsyncRuntime)
import class NIOAsyncRuntime.MultiThreadedEventLoopGroup
#elseif canImport(NIOPosix)
import class NIOPosix.MultiThreadedEventLoopGroup
#endif

let group = MultiThreadedEventLoopGroup(numberOfThreads: 1)

```

# Usage Examples

## Event loops with `MultiThreadedEventLoopGroup`

See [ExampleMTELG](Sources/ExampleMTELG/ExampleMTELG.md) for full example.

```swift
import protocol NIOCore.EventLoopGroup
import class NIOAsyncRuntime.MultiThreadedEventLoopGroup

let group = MultiThreadedEventLoopGroup()

let loop = group.next()
let future = loop.submit {
    "Hello World!"
}

future.whenSuccess { value in
    print(value)
}

// Shutdown when done
do {
    try await group.shutdownGracefully()
    print("Shutdown status: OK")
} catch {
    print("Shutdown status:", error)
}
```

## Thread pool work with `NIOThreadPool`

See [ExampleNIOThreadPool](Sources/ExampleNIOThreadPool/ExampleNIOThreadPool.md) for full example.

```swift
import protocol NIOCore.EventLoopGroup
import class NIOAsyncRuntime.AsyncEventLoop
import class NIOAsyncRuntime.NIOThreadPool

let pool = NIOThreadPool()
pool.start()

let loop = AsyncEventLoop()
let future = pool.runIfActive(eventLoop: loop) {
    return "Welcome to the Future!"
}

let result = try await future.get()
print("Result:", result)

// Clean up
do {
    try await loop.shutdownGracefully()
    try await pool.shutdownGracefully()
    print("Shutdown status: OK")
} catch {
    print("Shutdown status:", error)
}
```

# Benchmarks

NIOAsyncRuntime is currently significantly less performant than NIOPosix. Below are benchmark results run against both frameworks.

These benchmarks were [last run and updated on December 4, 2025](https://github.com/PassiveLogic/nio-async-runtime/pull/12).

| Benchmark                                                |      NIOPosix     | NIOAsyncRuntime |
| -------------------------------------------------------- | ----------------: | --------------: |
| Jump to EL and back using actor with EL executor         |  **1.44x faster** |      1.00x      |
| Jump to EL and back using execute and unsafecontinuation |  **1.31x faster** |      1.00x      |
| MTELG.scheduleCallback(in:)                              | **11.71x faster** |      1.00x      |
| MTELG.scheduleTask(in:)                                  |  **4.06x faster** |      1.00x      |
| MTELG.immediateTasksThroughput                           |  **4.92x faster** |      1.00x      |
