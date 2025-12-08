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
