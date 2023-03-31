/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

@testable import FBSDKLoginKit

import XCTest

final class NonceTests: XCTestCase {

  func testInvalidNonces() {
    [
      "",
      "foo bar",
    ].forEach { nonce in
      XCTAssertFalse(
        NonceValidator.isValid(nonce: nonce),
        "Should not consider: \(nonce) to be a valid nonce"
      )
    }
  }

  func testValidNonces() {
    [
      "123",
      "foo",
      "asdfasdfasdfasdfasdfasdfasdf",
    ].forEach { nonce in
      XCTAssertTrue(
        NonceValidator.isValid(nonce: nonce),
        "Should consider: \(nonce) to be a valid nonce"
      )
    }
  }
}
