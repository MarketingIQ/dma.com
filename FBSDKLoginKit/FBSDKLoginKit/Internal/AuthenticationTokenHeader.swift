/*
 * Copyright (c) Meta Platforms, Inc. and affiliates.
 * All rights reserved.
 *
 * This source code is licensed under the license found in the
 * LICENSE file in the root directory of this source tree.
 */

import FBSDKCoreKit_Basics

final class AuthenticationTokenHeader {

  /// Key identifier used in identifying the key to be used to verify the signature.
  let kid: String

  /// Returns a new instance, when one can be created from the parameters given, otherwise `nil`.
  /// - Parameter encodedHeader: Base64-encoded string of the header.
  /// - Returns: An FBAuthenticationTokenHeader object.
  init?(fromEncodedString encodedHeader: String) {
    guard
      let headerData = Base64.decode(asData: Base64.base64(fromBase64Url: encodedHeader)),
      let header = try? JSONSerialization.jsonObject(with: headerData, options: .mutableContainers) as? [String: Any],
      let alg = header["alg"] as? String,
      let typ = header["typ"] as? String,
      let kid = header["kid"] as? String,
      alg == "RS256",
      typ == "JWT",
      !kid.isEmpty
    else {
      return nil
    }

    self.kid = kid
  }
}
