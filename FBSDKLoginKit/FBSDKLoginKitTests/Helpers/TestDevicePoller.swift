/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import FBSDKLoginKit

final class TestDevicePoller: DevicePolling {
  var capturedInterval: UInt = 0

  func schedule(interval: UInt, block: @escaping () -> Void) {
    capturedInterval = interval
    block()
  }
}
