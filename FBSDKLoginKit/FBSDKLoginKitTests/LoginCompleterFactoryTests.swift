/*
 * Copyright (c) Facebook, Inc. and its affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKLoginKit
import TestTools
import XCTest

class LoginCompleterFactoryTests: XCTestCase {

  // swiftlint:disable implicitly_unwrapped_optional
  var graphConnection: TestGraphRequestConnection!
  var authenticationTokenFactory: TestAuthenticationTokenFactory!
  // swiftlint:enable implicitly_unwrapped_optional

  func testCreatingCompleterWithDependencies() {
    let completer = LoginCompleterFactory().createLoginCompleter(
      urlParameters: [:],
      appID: name,
      graphRequestConnectionFactory: TestGraphRequestConnectionFactory(),
      authenticationTokenCreator: TestAuthenticationTokenFactory()
    )
    XCTAssertTrue(
      completer is LoginURLCompleter,
      "Should create the expected concrete type of login completer"
    )
  }
}
