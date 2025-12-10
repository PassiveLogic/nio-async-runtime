# Overview

This example shows how to use the MultiThreadedEventLoopGroup. To allow
easy running on both macOS and WASI, the example uses NIOAsyncRuntime
for both macOS and WASI.

# Building and Running

## macOS

```zsh
swift run ExampleMTELG
```

## WASI

If needed, install the [latest Swift for Webassembly SDK](https://www.swift.org/documentation/articles/wasm-getting-started.html)

The instructions below assume the `swift-6.2.1-RELEASE_wasm` Swift SDK is installed. 

```zsh
swift run --swift-sdk swift-6.2.1-RELEASE_wasm ExampleMTELG
```

# Expected output

```zsh
Hello World!
Shutdown status: OK
```
