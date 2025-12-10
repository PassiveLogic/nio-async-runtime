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

import class NIOAsyncRuntime.MultiThreadedEventLoopGroup
import protocol NIOCore.EventLoopGroup

let group = MultiThreadedEventLoopGroup()

let loop = group.next()
let future = loop.submit {
    "Hello World!"
}

future.whenSuccess { value in
    print(value)
}

// Clean up
do {
    try await group.shutdownGracefully()
    print("Shutdown status: OK")
} catch {
    print("Shutdown status:", error)
}
