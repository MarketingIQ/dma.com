/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit
import Foundation

@objcMembers
final class TestLoggerFactory: NSObject, LoggerCreating {

  func createLogger(withLoggingBehavior loggingBehavior: LoggingBehavior) -> Logging {
    TestLogger(loggingBehavior: .developerErrors)
  }
}
