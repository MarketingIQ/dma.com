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
final class TestTokenCache: NSObject, TokenCaching {
  var accessToken: AccessToken?
  var authenticationToken: AuthenticationToken?

  init(
    accessToken: AccessToken? = nil,
    authenticationToken: AuthenticationToken? = nil
  ) {
    self.accessToken = accessToken
    self.authenticationToken = authenticationToken
  }
}
