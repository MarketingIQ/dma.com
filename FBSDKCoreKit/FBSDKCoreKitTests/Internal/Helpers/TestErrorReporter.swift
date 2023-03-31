/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

class TestErrorReporter: ErrorReporting {
  var wasEnableCalled = false
  var capturedErrorCode: Int?
  var capturedErrorDomain: String?
  var capturedMessage: String?

  func enable() {
    wasEnableCalled = true
  }

  func saveError(
    _ errorCode: Int,
    errorDomain: String,
    message: String?
  ) {
    capturedErrorCode = errorCode
    capturedErrorDomain = errorDomain
    capturedMessage = message
  }
}
